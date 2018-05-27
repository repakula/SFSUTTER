@isTest
public class EmployeeDistribution_Test{

    static testMethod void insertDuplicateEmpDist()
    {
		String errorMessage;
		Boolean isError = false;
		
    	try
			{
				Account acc = AP01_TestDataUtility.createSalesEmployerAccount();
				
				Account_Employee_Distribution__c empDist = AP01_TestDataUtility.createEmpDist(acc);
				
				Account_Employee_Distribution__c emp = new Account_Employee_Distribution__c();
				
				emp.Account__c = acc.id;
				emp.Region__c = 'SSR';
				emp.County__c = 'El Dorado';
				emp.County_Percent__c = 2;
				
				insert emp;
				
			} catch(Exception ex)
			{
				errorMessage = ex.getMessage();
				system.debug('@@Error Message : '+ ex.getMessage());
			}
		
		if(errorMessage.contains('Record already exists with same Region and County'))
		{
			isError = true;
		}
		
		system.assertEquals(isError, true);
    }
	
	static testMethod void updateDuplicateEmpDist()
    {
		String errorMessage;
		Boolean isError = false;
		
    	try
			{
				Account acc = AP01_TestDataUtility.createSalesEmployerAccount();
				
				Account_Employee_Distribution__c empDist = AP01_TestDataUtility.createEmpDist(acc);
				
				Account_Employee_Distribution__c emp = new Account_Employee_Distribution__c();
				
				emp.Account__c = acc.id;
				emp.Region__c = 'SSR';
				emp.County__c = 'Placer';
				emp.County_Percent__c = 2;
				
				insert emp;
				
				emp.County__c = 'El Dorado';
				update emp;
				
			} catch(Exception ex)
			{
				errorMessage = ex.getMessage();
				system.debug('@@Error Message : '+ ex.getMessage());
			}
		
		if(errorMessage.contains('Record already exists with same Region and County'))
		{
			isError = true;
		}
		
		system.assertEquals(isError, true);
    }
}