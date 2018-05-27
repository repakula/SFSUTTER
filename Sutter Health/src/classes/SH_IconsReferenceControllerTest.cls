@isTest
/*
    This class is used to cover the SH_IconsReferenceController 
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
*/
private class SH_IconsReferenceControllerTest 
{
    //this method is used to cover the positive scenario of UpdateSelectedIcon method
    static testMethod void ValidateIconRefrence() 
    {
        //Menu
        SH_Menu_Item__c objMenuItem = SH_CommonTest.CreateMenuItem('Benifit', 'Description', 1, true, true, 'Human Resource', 'HR Benefits');
        ApexPages.currentPage().getParameters().put('id',objMenuItem.Id);
        
        SH_IconsReferenceController objIconRefrence = new SH_IconsReferenceController();
        objIconRefrence.SelectedIconCss = 'test';
        objIconRefrence.UpdateSelectedIcon();
        objIconRefrence.Cancel();
    }
    //this method is used to cover the exception part of UpdateSelectedIcon method
     static testMethod void ValidateIconRefrence2() 
    {
        ApexPages.currentPage().getParameters().put('id','07MZ0000003OlhX');//hard coded Id is used to cover the test coverage only
        SH_IconsReferenceController objIconRefrence = new SH_IconsReferenceController();
        objIconRefrence.UpdateSelectedIcon();
       
    }
}