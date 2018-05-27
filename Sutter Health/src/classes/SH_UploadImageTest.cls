@isTest
private class SH_UploadImageTest 
{
    static testMethod void ValidateImageaUpload() 
    {
    	//Headliner data
		Contact_Script__kav objContactScript1 = SH_CommonTest.CreateArticleData('Nokia SMD Article', 'www-Nokia-com');
		SH_Home_Page_Headliner__c objHeadliner = SH_CommonTest.CreateHomePageHeadliner('Article Nokia', 'Description', 1, 'Article', true, true, String.valueOf(objContactScript1.KnowledgeArticleId).substring(0,15), '');
		
		SH_UploadImage objUpload = new SH_UploadImage();
		
		SH_CommonTest.CreateImageDimension('SH_Home_Page_Headliner__c' , 415, 1280, 'jpeg, gif, jpg, png');
		
		ApexPages.currentPage().getParameters().put('id',objHeadliner.Id);
		ApexPages.currentPage().getParameters().put('API','SH_Home_Page_Headliner__c');
		ApexPages.currentPage().getParameters().put('Name', objHeadliner.Name);
		
		objUpload = new SH_UploadImage();
		objUpload.fileBody = Blob.valueOf('Test image');
		objUpload.fileName = 'test.gif';
		objUpload.SaveAttachment();
		objUpload.Cancel();
    	
    }
}