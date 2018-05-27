/*
*    Test class to test the functionality of dataCategoryGroupInfo
*/
@isTest private class DataCategoryGroupInfoTest{

/* test method to test the functionality of dataCategoryGroupInfo */
    @isTest static void testDataCategoryInfo(){
        String name = 'TestName';
        String label = 'TestLabel';
        String displayName = 'TestDisplayName';
        String defaultValue = 'TestDefaultValue';
        
        List<DataCategoryInfo> groupStructureList = new List<DataCategoryInfo>();
        
        groupStructureList.add(new DataCategoryInfo(name, label, displayName));
        groupStructureList.add(new DataCategoryInfo(name, label, displayName));
        
        String groupName = 'TestNameGroup';
        String groupLabel = 'TestLabelGroup';
        String groupDescription = 'TestDescription';
        
        
        DataCategoryGroupInfo categoryGroupInfo = new DataCategoryGroupInfo(groupName, groupLabel, groupDescription, groupStructureList);
        categoryGroupInfo.getName();
        //Assert to check category group name
         System.assertNotEquals(null,categoryGroupInfo.getName());
        categoryGroupInfo.getLabel();
        categoryGroupInfo.getDescription();
        categoryGroupInfo.getGroupStructure();
        categoryGroupInfo.getValue();
        
        
    }
}