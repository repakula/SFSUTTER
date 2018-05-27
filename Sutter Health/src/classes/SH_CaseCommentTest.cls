@isTest
private class SH_CaseCommentTest 
{
    static testMethod void myUnitTest() 
    {
    	User objCommUser = SH_CommonTest.CreateCommunityUser();
 		Case objCase = SH_CommonTest.CreateCase(objCommUser.Id, objCommUser.ContactId, SH_Common.GetRecordTypeId('Case', 'Employee Inquiry'));
 		
 		system.runAs(objCommUser)
 		{
 			Apexpages.currentpage().getparameters().put('Id',objCase.Id);
 			SH_CaseComment objComment = new SH_CaseComment();
 			objComment.objCaseComment.CommentBody = 'test';
 			objComment.CreateComment();  
 		}   		
    }
}