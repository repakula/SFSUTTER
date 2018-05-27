/*
*    test class to test the functionality of DataCategoryUtil
*/
@isTest private class DataCategoryUtilTest {

/* test method to test the functionality of DataCategoryUtil */
    static testMethod void myUnitTest() {
        
        DataCategoryUtil dcu = DataCategoryUtil.getInstance();
            dcu.getAllCategoryGroups();
            //Assert to check data category group is not blank
           System.assertNotEquals(null,dcu.getAllCategoryGroups());
    }
}