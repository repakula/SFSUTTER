/**********************************************************************
Name: IdentifyMember
======================================================
======================================================
Purpose: Create Identify Member records 
-------	
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL Description
1.0 Brian Lee 05/27/2016 INITIAL DEVELOPMENT CSR:
***********************************************************************/
public class IdentifyMember {
    public static final String EFFECTIVE_DATE = 'LAST_N_DAYS:30';
    @TestVisible private static boolean throwException = false;
    
    /*******************************************************************
	Purpose: Upsert Identify_Member__c records for the specified contacts
	Parameters: set of contact ids that need identifymember records
	Returns: boolean to indicate success or failture of identifymember record upsert
	Throws [Exceptions]: None, Exceptions caught, Result log created
	********************************************************************/
    public static boolean createIdentifyMemberRecords(set<id> contactIdSet){
    	boolean success = true;
    	map<id,Contact> contactIdtoContactMap = new map<id, Contact>();
    	set<String> newPrimaryIdentifyMemberHCCIdSet = new set<String>();
    	set<String> memberSubHCCIdSet = new set<String>();
    	
    	for(Contact thisContact : [select FirstName, LastName, Member_ID__c, Member_Subscriber_HCC_ID__c, (select Name from PCP_Informations__r) from Contact where id in :contactIdSet]){
    		contactIdtoContactMap.put(thisContact.id,thisContact);
    		memberSubHCCIdSet.add(thisContact.Member_Subscriber_HCC_ID__c);
    		//Identify the Primary subscribers
    		if(thisContact.Member_ID__c.equals(thisContact.Member_Subscriber_HCC_ID__c)){
    			newPrimaryIdentifyMemberHCCIdSet.add(thisContact.Member_ID__c);
    		}
    	}
    	
    	//Identify existing Primary subscriber Identify Member records 
    	set<String> existingMemberHCCIdSet = new set<String>();
    	for(Identify_Member__c thisMember : [Select Member_ID__c from Identify_Member__c where Member_ID__c in :memberSubHCCIdSet]){
    		existingMemberHCCIdSet.add(thisMember.Member_ID__c);
    	}
    	
    	map<String,Identify_Member__c> identifyMemberPrimaryMap =  new map<String,Identify_Member__c>();
    	map<String,Identify_Member__c> identifyMemberDependentMap =  new map<String,Identify_Member__c>();
    	
    	for(Contact thisContact : contactIdtoContactMap.values()){
			Identify_Member__c memberRecord = new Identify_Member__c();
			memberRecord.contact__c = thisContact.id;
			memberRecord.Member_Name__c = thisContact.FirstName + ' ' + thisContact.LastName;
			memberRecord.PCP_Information__c = thisContact.PCP_Informations__r != null && thisContact.PCP_Informations__r.size() > 0 ? thisContact.PCP_Informations__r[0].id : null;
			memberRecord.Member_ID__c = thisContact.Member_ID__c;
			memberRecord.Process_Started__c = Date.today();
			//Is this the subscriber or a dependent
			if(newPrimaryIdentifyMemberHCCIdSet.contains(memberRecord.Member_ID__c)){
				identifyMemberPrimaryMap.put(memberRecord.Member_ID__c, memberRecord);
			}else{
				Identify_Member__c tempIdentMemberRef = new Identify_Member__c(Member_ID__c = thisContact.Member_Subscriber_HCC_ID__c);
				memberRecord.Member_Subscriber_IM_Record__r = tempIdentMemberRef;
				
				//if the primary does not exist or is not currently being inserted then need to insert the place holder primary
				if(!existingMemberHCCIdSet.contains(tempIdentMemberRef.Member_ID__c) && !newPrimaryIdentifyMemberHCCIdSet.contains(tempIdentMemberRef.Member_ID__c)){
					Identify_Member__c tempIdentMember =  new Identify_Member__c(Member_ID__c = tempIdentMemberRef.Member_ID__c);
					identifyMemberPrimaryMap.put(tempIdentMember.Member_ID__c, tempIdentMember);
				}
				identifyMemberDependentMap.put(memberRecord.Member_ID__c, memberRecord);
			}
			
    	}
    	try{
    		upsert identifyMemberPrimaryMap.values() Member_ID__c;
    		upsert identifyMemberDependentMap.values() Member_ID__c;
    		if(Test.isRunningTest() && throwException){
    			insert new Contact(id = '123');
    		}
    	}
    	catch(Exception e){
    		success = false;
    		insert new Result_Log__c(Batch_Job_Name__c = 'IdentifyMember.cls', Message__c = contactIdSet + 'ERROR - ' + e.getTypeName() + ' : ' + e.getMessage());
    		
    	}
    	return success;
    }
}