/*
    This class is used to cover the SH_CaseDetail class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok Verma              05/10/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_CaseDetailTest {

    static testmethod void validateHelp_SupportTest()
    {
        
        string strRecID = SH_Common.GetRecordTypeId('Case', 'Employee Inquiry');
        Test.startTest();
        User objUser = SH_CommonTest.CreateCommunityUser();
        Case objcase = SH_CommonTest.CreateCase(objUser.id, objUser.contactid, strRecID);
        Test.stopTest();

        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('Id',objcase.ID);
            SH_CaseDetail objCaseDetail = new SH_CaseDetail();
        }
    }
}