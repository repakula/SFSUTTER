/**********************************************************************
Name: IdentifyMember_Test
======================================================
======================================================
Purpose: Test IdentifyMember_Batch and  IdentifyMember
-------	
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL Description
1.0 Brian Lee 05/27/2016 INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class IdentifyMember_Test {
	private static Integer CREATE_ACCOUNTS = 100;
	private static Integer CREATE_CONTACTS = 500;
	
	/*******************************************************************
	Purpose: Create the test data for use test
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
	@testSetup static void myTestSetup(){
		list<Account> testAccountList = new list<Account>();
		id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SHP Subscriber').getRecordTypeId();
		for(integer i = 0; i < CREATE_ACCOUNTS; i++){
			String hCCId = 'TESTM00000' + i + '-01';
			testAccountList.add(new Account(
									Name = 'TestAccount ' + i,
									recordTypeId = accountRecordType,
									Account_External_ID1__c = hCCId,
									Subscriber_HCC_ID__c = hCCId
								));
		}
		insert testAccountList;
		list<String> groupAffiliateList = new list<String>{'ABMG','MPN','PAFMG','SEBMF','SMGR'};
		list<String> accountTypeList = new list<String>{'LrgGrp','SmGrp','Indvl'};
		list<Contact> testContactList = new list<Contact>();
		
		map<String,Integer> usedPrimaryCountMap = new map<String,Integer>();
		id contactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Member').getRecordTypeId();
		for(integer i = 0; i < CREATE_CONTACTS; i++){
			Account thisAccount = testAccountList[getRandom(CREATE_ACCOUNTS-1)];
			String memberID = thisAccount.Subscriber_HCC_ID__c;
			boolean primary = false;
			if(usedPrimaryCountMap.containsKey(memberID)){
				integer lastNum = usedPrimaryCountMap.get(memberID) + 1;
				usedPrimaryCountMap.put(memberID, lastNum);
				memberID = memberID.split('-')[0] + '-0' + lastNum; 	
			}
			else{
				usedPrimaryCountMap.put(memberID, 1);
				primary = true;
			}
			testContactList.add(new Contact(
									Firstname = getRandom(1) == 0 ? 'John' : 'Jane',
									Lastname = 'Doe' + i,
									recordTypeId = contactRecordType,
									Member_Group_Affiliation__c = groupAffiliateList[getRandom(groupAffiliateList.size()-1)],
									Member_Account_Type__c = accountTypeList[getRandom(accountTypeList.size()-1)],
									Member_EmployerSub_Name__c = 'TestBusiness ' + i,
									Member_Employer_Sub_HCC_ID__c = String.valueOf(getRandom(999999)).leftPad(6).replaceAll(' ', '0'),
									Member_Subscriber_HCC_ID__c = thisAccount.Subscriber_HCC_ID__c,
									Member_Effective_Date__c = Date.today() - getRandom(50),
									Member_Employer_HCC_ID__c = '',
									Member_ID__c = memberID,
									Contact_External_ID1__c = memberID,
									Gender__c = getRandom(1) == 0 ? 'M' : 'F',
									Member_Subscriber_Relationship__c = primary ? 'Sub' : 'Dependent',
									Birthdate = Date.today() - getRandom(36500),
									Member_Resi_Address1__c = '',
									Member_Resi_Address_City__c = '',
									Member_Resi_Address_State__c = '',
									Member_Resi_Address_Zip__c = '',
									Member_Resi_Address_County__c = '',
									AccountId = thisAccount.id,
									Identify_Member__c = getRandom(1) == 0 ? true : false
								));
		}
		insert testContactList;
	}
	
	/*******************************************************************
	Purpose: test the identifymember class
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
    @isTest static void testIdentifyMember() {
        set<id> contactList = new set<id>();
        for(Contact thisContact : [select Identify_Member__c from Contact]){
        	if(thisContact.Identify_Member__c){
        		contactList.add(thisContact.id);
        	}
        }
        system.assert(IdentifyMember.createIdentifyMemberRecords(contactList));
        IdentifyMember.throwException = true;
        IdentifyMember.createIdentifyMemberRecords(contactList);
        
    }
    
   /*******************************************************************
	Purpose: Test the identifymember_batch class
	Parameters: none
	Returns: none
	Throws [Exceptions]: None
	********************************************************************/
     /*@isTest static void testIdentifyMember_Batch() {
        Test.startTest();
        IdentifyMember_Batch thisBatch = new IdentifyMember_Batch();
        system.assert(thisBatch.effectiveDateString.equals(IdentifyMember.EFFECTIVE_DATE));
        thisBatch = new IdentifyMember_Batch('LAST_N_DAYS:30');
        system.assert(thisBatch.effectiveDateString.equals('LAST_N_DAYS:30'));
        Id batchInstanceId = Database.executeBatch(thisBatch, 2000);
        Test.stopTest();
    }*/
    
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