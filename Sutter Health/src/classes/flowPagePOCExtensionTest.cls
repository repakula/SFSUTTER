/**  
*    Class Name: flowPagePOCExtensionTest
*    Author: Rahul
*    Date: 23-December-2013
*    Description:  An apex page controller that tests the flowPagePOCExtension Class
*    History
*    --------
**/
@isTest(seeAllData=true)

private class flowPagePOCExtensionTest{

	 /**   
*@author IDC Team    
*@date 01/01/2014    
*@description This method internally calls the getSearchTag method.
*@param     
*@return     
*/
@isTest private static void searchTag(){

flowPagePOCExtension  flp = new flowPagePOCExtension();
//Flow.Interview.Portal_FLOW myFlow = Flow.Portal_FLOW;
flp.getSearchTag();

}
}