/*
    This class is used to cover the SH_MyCases class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          31/08/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_MyCasesTest { 

    static testmethod void ValidateMyCase()
    {   
        Test.startTest();
        User objUser = SH_CommonTest.CreateCommunityUser();
        Test.StopTest();

        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('C','C');
            SH_MyCases objMyCases = new SH_MyCases();
            Apexpages.currentpage().getparameters().put('C','D');
            SH_MyCases objMyCases2 = new SH_MyCases();
            objMyCases2.selectedSortField ='Date (Newest First)';
            objMyCases2.sortCases();
            objMyCases2.selectedSortField ='Date (Oldest First)';
            objMyCases2.sortCases();
            objMyCases2.selectedSortField ='Status (Ascending)';
            objMyCases2.sortCases();
            objMyCases2.selectedSortField ='Status (Descending)';
            objMyCases2.sortCases();
        }
    }
}