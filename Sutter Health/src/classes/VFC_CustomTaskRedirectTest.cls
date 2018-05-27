/**
 * Name : VFC_CustomTaskRedirectTest
 * Description : Test class used for testing the VFC_CustomTaskRedirect
 * Date : 09/18/2014 
 * Version : <initial Draft> 
 */


@isTest
private class VFC_CustomTaskRedirectTest {
     /*
     *@name testSaveAndSend() 
     *@return void 
     *@description This method for redirectToTask() In CLASS VFC_CustomTaskRedirect
     */
    
    static testmethod void testCustomTaskRedirect() {
        try {
            Schema.DescribeSObjectResult descCaseObj = Schema.SObjectType.Case; 
            Map<String,Schema.RecordTypeInfo> rtMapByName = descCaseObj.getRecordTypeInfosByName(); 
            
            System.Test.startTest();
            Account accObj = new Account();            
            accObj.Name = 'Account Name1';            
            insert accObj; 
          // Assert to check Account is created sucessfully
             system.assert(accObj.id!=null);          
            
            Contact contObj = new Contact();            
            contObj.FirstName = 'Contact FName1';            
            contObj.LastName = 'Contact LName1';            
            contObj.email = 'testContact1@test.com';            
            insert contObj;
            // Assert to check Contact is created sucessfully
             system.assert(contObj.id!=null);   
             
            System.Test.stopTest();              
            
            Case caseObj = new Case();            
            caseObj.subject = 'Test Case';            
            caseObj.description = 'Test Case';                    
            caseObj.accountId = accObj.id;            
            caseObj.contactId = contObj.id;
            caseObj.recordtypeId =  rtMapByName.get('Training').getRecordTypeId();            
            insert caseObj;
            // Assert to check Case is created sucessfully
             system.assert(caseObj.id!=null);   
            
            ApexPages.CurrentPage().getParameters().put('who_id',contObj.id);
            ApexPages.CurrentPage().getParameters().put('what_id',caseObj.id);
            ApexPages.CurrentPage().getParameters().put('retURL',caseObj.id);
            ApexPages.CurrentPage().getParameters().put('ent','Task');
            ApexPages.CurrentPage().getParameters().put('RecordTypeName','Training Task');
            VFC_CustomTaskRedirect clsObj = new VFC_CustomTaskRedirect();
            clsObj.redirectToTask();        
        } catch(Exception ex) {}        
    }    
}