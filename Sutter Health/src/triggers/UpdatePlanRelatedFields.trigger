/**  
*    Trigger Name: UpdatePlanRelatedFields 
*    Author:Saket Jha
*    Date: 09-April-2014
*    Description: This Trigger is written to associate appropriate competitor plan with SHP Plan of particular opportunity.
*    History
*    --------
*    VERSION    AUTHOR           DATE        DETAIL 
*       1.0     IDC Offshore   04/09/2014  Ad ded Comments and Indentation
**/

   trigger UpdatePlanRelatedFields on SHP_Plans__c (before insert,before update) 
           
           {
            
             Set<Id> shpIds = new Set<Id>();
             
             Set<Id> compIds = new Set<Id>();
             
             Set<Id> quoteIds = new Set<Id>();
             
             for(SHP_Plans__c shp : trigger.new)
              
             {    
               shpIds.add(shp.SHP_Product__c);
                                  
              }               
                 
            Map<Id,SHP_Product__c> shpProdMap = new Map<Id, SHP_Product__c>([SELECT Id,RX_Deductible__c,RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,Deductible__c,CoInsurance__c,PCP__c,OOPM__c,SPC__c,Plan__c FROM SHP_Product__c where Id IN :shpIds]);
                      
            for(SHP_Plans__c sh : trigger.new){
            
            SHP_Product__c shpProd = shpProdMap.get(sh.SHP_Product__c);
                       
            
              if(shpProd!=null)
              {
                sh.plan__c = shpProd.plan__c;
                sh.Deductible__c = shpProd.Deductible__c;
                sh.CoInsurance__c = shpProd.CoInsurance__c;
                sh.PCP__c = shpProd.PCP__c;
                sh.OOPM__c =shpProd.OOPM__c;
                sh.SPC__c = shpProd.SPC__c;
                sh.RX_Deductible__c = shpProd.RX_Deductible__c ;
                sh.RX_Tier_1__c = shpProd.RX_Tier_1__c;
                sh.RX_Tier_2__c = shpProd.RX_Tier_2__c;
                sh.RX_Tier_3__c = shpProd.RX_Tier_3__c;
                
               }
            
                     
              }
            }