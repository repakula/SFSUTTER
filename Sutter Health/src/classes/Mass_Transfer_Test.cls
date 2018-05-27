/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Mass_Transfer_Test {
	private static Integer CREATE_CASE = 300;
	private static Integer CREATE_OWNER = 5;
	private static Integer TEST_KEY = 10;
	private static list<User> testUserList;
	private static  list<id> recordTypeIdList;
	/*******************************************************************
	Purpose: Create the test data for use test
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
	@testSetup static void myTestSetup(){
		//create users records
		//Profiles with read permission to case object
		set<Id> profileSet = new set<id>();
		for(ObjectPermissions tempPermission : [select parent.Profile.Id from ObjectPermissions where SObjectType = 'Case' AND PermissionsRead = true AND parent.Profile.Id != null]){
			profileSet.add(tempPermission.parent.Profile.Id);
		}
		list<Profile> profileList = [Select id from profile where UserType = 'Standard' AND id in :profileSet];
		testUserList = new list<User>();
		for(integer i = 0; i < CREATE_CASE; i++){
			testUserList.add((User)User.sObjectType.newSObject(null,true));
			testUserList[i].Username = 'abc' + i + '@testorg.com.test';
			testUserList[i].LastName = 'test' +i;
			testUserList[i].Email = 'abc' + i + '@testorg.com';
			testUserList[i].Alias = 'test' + i;
			testUserList[i].CommunityNickname = 'tes' + i;
			testUserList[i].TimeZoneSidKey = 'America/Los_Angeles';
			testUserList[i].LocaleSidKey = 'en_US';
			testUserList[i].EmailEncodingKey = 'UTF-8';
			testUserList[i].ProfileId = profileList[getRandom(profileList.size()-1)].id;
			testUserList[i].LanguageLocaleKey = 'en_US';
		}
		insert testUserList;
		//create case
		//Function List
		list<String> functionList = new list<String>();
		Schema.DescribeFieldResult fieldResult = Case.Function__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry f : ple){
			functionList.add(f.getValue());
		}
		//Sub Funtion List
		list<String> subFunctionList = new list<String>();
		fieldResult = Case.Sub_Function__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry f : ple){
			subFunctionList.add(f.getValue());
		}
		//Sub Funtion List
		list<String> teamList = new list<String>();
		fieldResult = Case.Team__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry f : ple){
			teamList.add(f.getValue());
		}
		//Record type list
        recordTypeIdList = new list<id>();
        Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
		for( String recordType : Mass_Transfer_CC.recordTypeNames){
			if(recordTypeMap.containsKey(recordType) && recordTypeMap.get(recordType).isAvailable()){
				recordTypeIdList.add(recordTypeMap.get(recordType).getRecordTypeId());
			}
		}
		list<Case> newCaseList = new list<Case>();
		for(integer i = 0; i < CREATE_CASE; i++){
			newCaseList.add((Case)Case.sObjectType.newSObject(recordTypeIdList[getRandom(recordTypeIdList.size()-1)], true));
			newCaseList[i].Function__c = functionList[getRandom(functionList.size()-1)];
			newCaseList[i].Sub_Function__c = subFunctionList[getRandom(subFunctionList.size()-1)];
			newCaseList[i].OwnerId = testUserList[getRandom(testUserList.size()-1)].id;
			newCaseList[i].Team__c = teamList[getRandom(teamList.size()-1)];
		}
		insert newCaseList;
		
	}
	/*******************************************************************
	Purpose: test the Mass_Transfer_CC class.
	This will test filering using function and will take ownership of 10 records
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
    @isTest static void testMassTransfer() {
        map<String,Integer> keyToCountMap = new map<String,Integer>();

        for(Case thisCase :  [Select Sub_Function__c, Function__c, Team__c, owner.Name, RecordTypeId from case where Owner.Type = 'User' AND Status not in: Mass_Transfer_CC.IGNORE_STATUS]){
        	
        	if(String.isNotBlank(thisCase.Function__c) && String.isNotBlank(thisCase.Sub_Function__c) && String.isNotBlank(thisCase.Team__c)){
        		String tempKey = thisCase.Function__c + ':' + thisCase.Sub_Function__c + ':' + thisCase.Team__c;
        		if(keyToCountMap.containsKey(tempKey)){
        			keyToCountMap.put(tempKey, (keyToCountMap.get(tempKey) + 1));
        		}
        		else{
        			keyToCountMap.put(tempKey, 1);
        		}
        	}
        	
        }
        recordTypeIdList = new list<id>();
        Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
		for( String recordType : Mass_Transfer_CC.recordTypeNames){
			if(recordTypeMap.containsKey(recordType) && recordTypeMap.get(recordType).isAvailable()){
				recordTypeIdList.add(recordTypeMap.get(recordType).getRecordTypeId());
			}
		}
        
        PageReference pageRef = Page.Mass_Transfer;
        Test.setCurrentPage(pageRef);
        set<Id> availableRecTypes = new set<Id>();
        availableRecTypes.addAll(recordTypeIdList); 
        Mass_Transfer_CC sCController = new Mass_Transfer_CC();
        for(SelectOption recTypeSelList : sCController.getRecordTypeSelectOptions()){
        	//Exclude the None option
        	if(String.isNotBlank(recTypeSelList.getValue())){
        		system.assert(availableRecTypes.contains(recTypeSelList.getValue()));
        	}
        }
        list<String> keyList = new list<String>(); 
        keylist.addAll(keyToCountMap.keySet());
        if(!keylist.isEmpty()){
	        Test.startTest();
        	String randomKey = keylist[getRandom(keyList.size()-1)];
        	list<String> splitKey = randomKey.split(':');
        	sCController.tempCase.Function__c = splitKey[0];
        	sCController.tempCase.Sub_Function__c = splitKey[1];
        	sCController.tempCase.Team__c = splitKey[2];
        	sCController.selectedRecordType = recordTypeIdList[getRandom(recordTypeIdList.size()-1)];
        	sCController.queryCases();
        	//Modify the sort by
        	sCController.SortExpression = sCController.SortExpression.equals('Function__c') ? 'Sub_Funtion__c' : 'Function__c';
        	//Toggle the sorting direction
        	sCController.SortDirection = sCController.SortDirection.equals('ASC') ? 'DESC' : 'ASC';
        	sCController.SortDirection = sCController.SortDirection;
        	sCController.queryCases();
        	list<Case> partialList = sCController.getCaseList();
        	system.assert(sCController.ResultSize == keyToCountMap.get(randomKey));
        	Integer currentPage = sCController.setMass_Transfer.getPageNumber();
        	sCController.nextPage();
        		//Next page of cases
        	if(partialList.size() < sCController.ResultSize){	
        		system.assert(sCController.setMass_Transfer.getPageNumber() > currentPage);
        	}
        	else{
        		system.assert(sCController.setMass_Transfer.getPageNumber() == currentPage);
        	}
        	system.assert(sCController.getPageNumber() == sCController.setMass_Transfer.getPageNumber());
        	
        	sCController.previousPage();
        		//prev page of cases
        	system.assert(sCController.setMass_Transfer.getPageNumber() == currentPage);
        	//Select 1 that will have owner changed
        	set<id> selectedCase = new set<id>();
        	for(integer j = 0; j < 10; j++){
        		Id tempId = partialList[getRandom(partialList.size()-1)].id;
        		selectedCase.add(tempId);
        		//Confirm that the checked map contains the id of the available case
        		system.assert(sCController.caseChecked.containsKey(tempId));
        		sCController.caseChecked.put(tempId,true);
        	}
        	sCController.tempCase.OwnerId = UserInfo.getUserId();
        	sCController.updateOwner();
        	for(Case tempCase : [Select ownerId from case where id in: selectedCase]){
        		system.assert(tempCase.ownerId == UserInfo.getUserId());	
        	}
	        Test.stopTest();
        }
    }
    /*******************************************************************
	Purpose: test the Mass_Transfer_CC class
	This will test filering using a username and will take ownership of 1 record.  Will also test throwing of exception using the
	static variable 'Mass_Transfer_CC.THROW_EXCEPTION = true' for code test coverage
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
    @isTest static void testMassTransferOwnerQuery() {
       
        map<String,Integer> ownerToCountMap = new map<String,Integer>();
        for(Case thisCase :  [Select Sub_Function__c, Function__c, Team__c, owner.Name, RecordTypeId from case where Owner.Type = 'User' AND Status not in: Mass_Transfer_CC.IGNORE_STATUS]){
        	if(String.isNotBlank(thisCase.owner.Name)){
        		if(ownerToCountMap.containsKey(thisCase.owner.Name)){
        			ownerToCountMap.put(thisCase.owner.Name, (ownerToCountMap.get(thisCase.owner.Name) + 1));
        		}
        		else{
        			ownerToCountMap.put(thisCase.owner.Name, 1);
        		}
        	}
        }
        recordTypeIdList = new list<id>();
        Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
		for( String recordType : Mass_Transfer_CC.recordTypeNames){
			if(recordTypeMap.containsKey(recordType) && recordTypeMap.get(recordType).isAvailable()){
				recordTypeIdList.add(recordTypeMap.get(recordType).getRecordTypeId());
			}
		}
        
        PageReference pageRef = Page.Mass_Transfer;
        Test.setCurrentPage(pageRef);
        set<Id> availableRecTypes = new set<Id>();
        availableRecTypes.addAll(recordTypeIdList); 
        Mass_Transfer_CC sCController = new Mass_Transfer_CC();
        for(SelectOption recTypeSelList : sCController.getRecordTypeSelectOptions()){
        	//Exclude the None option
        	if(String.isNotBlank(recTypeSelList.getValue())){
        		system.assert(availableRecTypes.contains(recTypeSelList.getValue()));
        	}
        }
        list<String> ownerList = new list<String>(); 
        ownerlist.addAll(ownerToCountMap.keySet());
        if(!ownerlist.isEmpty()){
	        Test.startTest();
        	String randomOwner = ownerlist[getRandom(ownerlist.size()-1)];
        	sCController.ownerName = randomOwner;
        	sCController.queryCases();
        	list<Case> partialList = sCController.getCaseList();
        	system.assert(sCController.ResultSize == ownerToCountMap.get(randomOwner));
        	Integer currentPage = sCController.setMass_Transfer.getPageNumber();
        	sCController.nextPage();
        		//Next page of cases
        	if(partialList.size() < sCController.ResultSize){	
        		system.assert(sCController.setMass_Transfer.getPageNumber() > currentPage);
        	}
        	else{
        		system.assert(sCController.setMass_Transfer.getPageNumber() == currentPage);
        	}
        	sCController.previousPage();
        		//prev page of cases
        	system.assert(sCController.setMass_Transfer.getPageNumber() == currentPage);
        	//Select 10 that will have owner changed
        	set<id> selectedCase = new set<id>();
        	for(integer j = 0; j < 1; j++){
        		Id tempId = partialList[getRandom(partialList.size()-1)].id;
        		selectedCase.add(tempId);
        		//Confirm that the checked map contains the id of the available case
        		system.assert(sCController.caseChecked.containsKey(tempId));
        		sCController.caseChecked.put(tempId,true);
        	}
        	sCController.tempCase.OwnerId = UserInfo.getUserId();

        	sCController.updateOwner();
        	
        	for(Case tempCase : [Select ownerId from case where id in: selectedCase]){
        		system.assert(tempCase.ownerId == UserInfo.getUserId());	
        	}
        	randomOwner = ownerlist[getRandom(ownerlist.size()-1)];
        	sCController.ownerName = randomOwner;
        	sCController.queryCases();
        	for(integer j = 0; j < 10; j++){
        		Id tempId = partialList[getRandom(partialList.size()-1)].id;
        		//Confirm that the checked map contains the id of the available case
        		system.assert(sCController.caseChecked.containsKey(tempId));
        		sCController.caseChecked.put(tempId,true);
        	}
        	sCController.tempCase.OwnerId = UserInfo.getUserId();
        	Mass_Transfer_CC.THROW_EXCEPTION = true;
        	sCController.updateOwner();
	        Test.stopTest();
        }
    }
    
    
     /*******************************************************************
	Purpose: Create a random number between 0 and a specified max
	Parameters: integer to specify the max 
	Returns: integer 
	Throws [Exceptions]: None
	********************************************************************/
    private static Integer getRandom(integer maxNumber){
    	return Math.round(Math.random() * maxNumber);
    }
}