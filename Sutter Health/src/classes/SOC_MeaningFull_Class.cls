public class SOC_MeaningFull_Class {
    
    //Meaningul
    public List<Case> socCaseList {get; set;}
    public Boolean isLoggedIn {get; set;}
    public string username {get; set;}
    public string password {get; set;}
    public Map<String, MeaningfulUse_Site_Credentials__c> newCustSettMap{get; set;}
    String socRT = '';
    public String provider_EAF_Id {get; set;}
    List<SOC_Queue__c> queueList = new List<SOC_Queue__c>();
    public Map<String, String> mapCaseIdToSOCId {get; set;}

    public SOC_MeaningFull_Class(){
        
        try{
            provider_EAF_Id = '';
            isLoggedIn = false;
            mapCaseIdToSOCId = new Map<String, String>();
            newCustSettMap = new Map<String, MeaningfulUse_Site_Credentials__c>();
            Cookie loggedInCookie = ApexPages.currentPage().getCookies().get('loggedInUser');
            system.debug('@@loggedInCookie : '+ loggedInCookie);
            
                    
            if(loggedInCookie <> null){
                system.debug('@@loggedInCookie : '+ loggedInCookie.getValue());
                if(loggedInCookie.getValue() <> 'userloggedout'){
                    isLoggedIn = true;
                    
                }
            }
            
            String backToParameter = ApexPages.currentPage().getParameters().get('backto');
            
            if(!String.isBlank(backToParameter) && backToParameter == 'true'){
            	query_soc_list_map_method();
            }
            
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage())); 
        }
    }
    
    public void actionMethod(){
    	
    }
    
    //
    public void loginMethod(){
        
        try{
            
            newCustSettMap = MeaningfulUse_Site_Credentials__c.getAll();
            system.debug('@@newCustSettMap : '+ newCustSettMap);
            
            if(!string.isBlank(username) && !string.isBlank(password)){
                
                if(!newCustSettMap.isEmpty()){
                    
                    for(MeaningfulUse_Site_Credentials__c custSett : newCustSettMap.values()){
                        
                        if(username == custSett.username_cust_sett__c && password == custSett.password_cust_sett__c){
                            
                            isLoggedIn = true;
                            Cookie loggedInCookie = new Cookie('loggedInUser', username ,null, -1, false);
                            ApexPages.currentPage().setCookies(new Cookie[]{loggedInCookie});
                            
                            query_soc_list_map_method();
                        }
                    }
                    if(isLoggedIn == false){
                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please check your Username or Password.'));
                    }
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please fill username and password'));
            }
            Cookie checkCookie = ApexPages.currentPage().getCookies().get('loggedInUser');
            system.debug('@@checkCookie : '+ checkCookie);
        }catch(Exception classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage())); 
        } 
    }
    
    //
    public Pagereference logoutFromSite(){
        
        Cookie loggedInCookie = new Cookie('loggedInUser', 'userloggedout' ,null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{loggedInCookie});
        
        Cookie checkCookie = ApexPages.currentPage().getCookies().get('loggedInUser');
        system.debug('@@checkCookie : '+ checkCookie);
        
        Pagereference pageref = new Pagereference('/Meaningfuluse/SOCMeaningFul');
        pageref.setRedirect(true);
        return pageref;
    }
    
    private void query_soc_list_map_method(){
    	socCaseList = new List<Case>();
    	socRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Summary_of_Care).getRecordTypeId();
    	
    	socCaseList = [select id, (select id, Associated_Case_Id__c from SOC_Queues__r), CaseNumber, Provider_Type__c, Provider_Name__c,Provider_Id_EAF_ID__c, 
                                                PDV_Escalation_Reason__c, Owner.Name, EAF_Facility__c, ContactId
                                                FROM Case
                                                WHERE RecordtypeId =:socRT AND status =: 'Escalate To Meaningful Use'
                                                ORDER BY CaseNumber DESC];
                           
        system.debug('@@socCaseList : '+ socCaseList);
        for(Case caseOne : socCaseList)
        {
            for(SOC_Queue__c soc : caseOne.SOC_Queues__r)
            {
                queueList.add(soc);
            }
        }
        
        for(SOC_Queue__c soc : queueList){
            
            mapCaseIdToSOCId.put(soc.Associated_Case_Id__c, soc.Id);
        }
        
        for(Case caseOne : socCaseList){
            
            if(!mapCaseIdToSOCId.containsKey(caseOne.Id)){
                mapCaseIdToSOCId.put(caseOne.id, '');
            }
        }
    }
}