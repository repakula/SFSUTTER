@isTest
private class DataCategoryInfoTest {

@isTest static void Contact_testDataCategory(){
	
	String name='Test';
 	String label='TestLab';
 	String displayName ='TestDisplay';
 	
 	DataCategoryInfo dt= new DataCategoryInfo(name,label,displayName);
 	
 		dt.getName();
 		dt.getLabel();
 		dt.getDisplayName();
 	
	  System.assertEquals(name,dt.getName());
	  System.assertEquals(label,dt.getLabel());
	  System.assertEquals(displayName,dt.getDisplayName());
}
 
}