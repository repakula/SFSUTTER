@isTest
private class SH_ToggleWebServiceTest 
{
    static testMethod void ValidateToggleWebService() 
    {
    	//Headliner data
		Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData('Nokia SMD Article', 'www-Nokia-com');
		SH_Home_Page_Headliner__c objHeadliner = SH_CommonTest.CreateHomePageHeadliner('Article Nokia', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript1.KnowledgeArticleId).substring(0,15), '');
		
		SH_ToggleWebService.togglePublishChk(null, 'SH_Is_Publish__c', objHeadliner.Id);
		SH_ToggleWebService.togglePublishChk('SH_Homekjkj_Page_Headliner__c', 'SH_Is_Publish__c', objHeadliner.Id);
        SH_ToggleWebService.togglePublishChk('SH_Home_Page_Headliner__c', 'SH_Is_Publish__c', objHeadliner.Id);
    }
}