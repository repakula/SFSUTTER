@isTest

private class UpdatePlanRelatedFieldsTest {

 static testMethod void updatePlanRelFields()
 {
     quote__c qt = new quote__c();
     qt.name = 'Test Quote';
     insert qt;
     // Assert to check Quote is created sucessfully
     system.assert(qt.id!=null);
     
     SHP_Product__c  shprod = new SHP_Product__c ();
     shprod.name='M12';
     shprod.plan__c = 'ML01 - LG Standard $10 - $500';
     insert shprod;
      // Assert to check SHP_Product__c is created sucessfully
     system.assert(shprod.id!=null);
     
     SHP_Plans__c sh = new SHP_Plans__c();
     
      sh.quote__c= qt.id;
      sh.SHP_Product__c =shprod.id;
      sh.EE_CC_Rate__c=10;
      sh.EE_Family_Rate__c=10;
      sh.EE_S_Rate__c = 10;
      
      insert sh;
      // Assert to check SHP_Plans__c is created sucessfully
     system.assert(sh.id!=null);
 
 }


}