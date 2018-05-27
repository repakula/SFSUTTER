trigger TRG_MU_Object on MU_Object__c (after insert) {
	
	List<Case> associatedCases = new List<Case>();
	Map<String, MU_Object__c> caseIdMUObjectMap = new Map<String, MU_Object__c>();
	List<Case> caseToupdate = new List<Case>();
	
	try{
		for(MU_Object__c mu : Trigger.new){
			
			if(mu.Case__c <> null){
				caseIdMUObjectMap.put(mu.Case__c, mu);
			}
		}
	
		if(!caseIdMUObjectMap.isEmpty()){
			
			associatedCases = [Select Id from Case where Id IN : caseIdMUObjectMap.keySet()];
		}
		
		if(!associatedCases.isEmpty()){
			
			for(Case assoCase : associatedCases){
				assoCase.OwnerId = Userinfo.getUserId();
				assoCase.Status = caseIdMUObjectMap.get(assoCase.Id).Status__c;
				assoCase.MU_Comments__c = caseIdMUObjectMap.get(assoCase.Id).Comments__c;
				assoCase.MU_Escalation_Status__c = caseIdMUObjectMap.get(assoCase.Id).Escalation_Status__c;
				caseToupdate.add(assoCase);
			}
		}
		
		if(!caseToupdate.isEmpty()){
			
			Database.update(caseToupdate);
		}
	}catch(Exception classException){
		Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
	}
}