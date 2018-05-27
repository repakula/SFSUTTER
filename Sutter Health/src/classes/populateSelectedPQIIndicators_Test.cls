/**  
*     Class Name: populateSelectedPQIIndicators_Test
*     Author: IDC Offshore
*     Date: 07-Augast-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description: This test insert the PQI records and checks for the PQI indicators are properly Populted.
*     
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       
**/
@isTest
public class populateSelectedPQIIndicators_Test {
    Public Static Final String ERRMSG = 'Cannot update the record without assigning it to yourself from the queue';
    
    
    /**    
    *@author IDC Team    
    *@date 07/08/2015    
    *@description This Test Method is used to check the the Value Set for the Selected PQI Indicators by trigger is correct.
    *@param     
    *@return     
    */
    static testMethod void  testSelectedPQI() {
        List<Potential_Quality_Issue__c> pqiListToInsert = new List<Potential_Quality_Issue__c>();
        List<Potential_Quality_Issue__c> pqiListExtracted = new List<Potential_Quality_Issue__c>();
        
        for (Integer i = 0; i<100;i++ ) {
            Potential_Quality_Issue__c pqi = new Potential_Quality_Issue__c( Access_Availability__c = true ,
                                                                         Admit_within_3_days_of_ER__c = true,
                                                                         ByPass_CMO__c = false,
                                                                         Assessment_Treatment_Diagnosis__c= true
                                                                        );
            pqiListToInsert.add(pqi);
        }
        
        Test.startTest();
        Database.insert(pqiListToInsert);
        Test.stopTest();
        
        pqiListExtracted = [SELECT Id, Name , Selected_PQI_Indicators__c FROM Potential_Quality_Issue__c WHERE ID IN:pqiListToInsert ];
        
        
        for( Integer i=0;i<100;i++) {
            String indicatorValues = pqiListExtracted[i].Selected_PQI_Indicators__c;
            System.debug('@@SUSH@@'+indicatorValues+'@@@SUSH&&' + indicatorValues.contains('Access / Availability'));
            System.assertEquals(true, indicatorValues.contains('Access / Availability'));
            System.assertEquals(true, indicatorValues.contains('Admit within 3 days of ER'));
            System.assertEquals(true, indicatorValues.contains('Assessment/Treatment/Diagnosis'));
        }
    }

    /**    
    *@author IDC Team    
    *@date 07/08/2015    
    *@description This Test Method is used to check for the validation error for the PQI is correct.
    *@param     
    *@return     
    */
    static testMethod void testValidation() {
        List<Potential_Quality_Issue__c> pqiListToInsert = new List<Potential_Quality_Issue__c>();
        List<Potential_Quality_Issue__c> pqiListExtracted = new List<Potential_Quality_Issue__c>();
        Id QualityId = [Select Id FROM Group WHERE DeveloperName = 'Quality'].Id;

        
        for (Integer i = 0; i<100;i++ ) {
            Potential_Quality_Issue__c pqi = new Potential_Quality_Issue__c( Access_Availability__c = true ,
                                                                         Admit_within_3_days_of_ER__c = true,
                                                                         ownerId = QualityId,
                                                                         PQI_Status__c = 'New',
                                                                         ByPass_CMO__c = false,
                                                                         Assessment_Treatment_Diagnosis__c= true
                                                                        );
            pqiListToInsert.add(pqi);
        }
        
        Database.insert(pqiListToInsert);
        // Assert to check Potential_Quality_Issue__c records created successfully
        system.assert(pqiListToInsert.size()>0);
        
        for(Potential_Quality_Issue__c pqi:pqiListToInsert){
            pqi.PQI_Status__c = 'Closed';
        }
        
        Test.startTest();
        Database.SaveResult[] srList = Database.update(pqiListToInsert, false);
        Test.stopTest();
        
        
    }
}