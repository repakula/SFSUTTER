/*****************************************************
Class Name: AutoAssignRecordsToAgentsController 
Created By: Nagarjuna Kaipu
Created Date: 12/04/2016
Description: This class is used to assign the non-validated provider records to agents
References: AutoAssignRecordsToAgents vf page
*****************************************************/
public with sharing class AutoAssignRecordsToAgentsController {
    public List<AgentStatsWrapper> agentStats{get; set;}
    public String selectedAssignBasedOn{get;set;}
    public String selectedSortingOrder{get;set;}
    public Integer recordCount{get;set;} //To hold record count to assign per agent
    private Map<Id, Integer> openTicketsCountMap = new Map<Id, Integer>(); //To show today open tickets per agent
    private Map<Id, Integer> closedTicketsCountMap = new Map<Id, Integer>(); //To show today closed tickets per agent
    private Map<Id, double> avgResTimeMap = new Map<Id, Decimal>(); //To show today tickets avg res time in mins per agent
    private Map<Id, Integer> campaignOpenTicketsCountMap = new Map<Id, Integer>(); //To show campaign to date open tickets per agent
    private Map<Id, Integer> campaignClosedTicketsCountMap = new Map<Id, Integer>(); //To show campaign to date closed tickets per agent
    private Map<Id, double> campaignAvgResTimeMap = new Map<Id, Decimal>(); //To show campaign to date tickets avg res time in mins per agent
    private List<Contact_Validation_Summary__c> recordsToUpdate = new List<Contact_Validation_Summary__c>();
    private List<Contact_Validation_Summary__c> nonValidatedRecList = new List<Contact_Validation_Summary__c>(); //To get the non validated records count
    private Map<Id, Boolean> selectedUsersMap = new Map<Id,Boolean>(); //populated only if agents selected
    private Map<Id, Integer> selectedUsersMapCount = new Map<Id,Integer>(); //populated only if agents selected
    private Set<Id> selectedUserIds = new Set<Id>();//We create a new list of Users that we be populated only with Users if they are selected
    private Set<Id> selectedUserPhoneIds = new Set<Id>();
    private Map<Id, Integer> usersWithCountMap = new Map<Id, Integer>(); //Map to hold the users along with the assigned records count
    public Boolean showAgents{get;set;}
    public Map<Id, User> availabeAgentsMap = new Map<Id, User>();//To get the available users under PDI profile
    public List<PDISelectedAgents__c> sAgentsList{get; set;} //To get the selected filter criteria from custom settings object
    public List<AgentStatsWrapper> agentListToDisplay {get; set;} //Wrapper list to display on the page
    
    /*Constructor to initialize the page*/
    public AutoAssignRecordsToAgentsController()
    {
        //Getting selected criteria from Custom Settings
        PDIAutoAssignSelectedCriteria__c selectedCriteria = 
            PDIAutoAssignSelectedCriteria__c.getInstance(Label.CL201_AutoAssignSelectedCriteria);
        if(selectedCriteria != null)
        {
            recordCount = Integer.valueOf(selectedCriteria.Record_Count_Per_Agent__c);
            selectedAssignBasedOn = selectedCriteria.Assign_Based_On__c;
            selectedSortingOrder = selectedCriteria.Sorting_Order__c;  
        }
        //Assigning Wrapper ressults to list to show on the page
        agentListToDisplay = new List<AgentStatsWrapper>();
        agentListToDisplay = getAgentList();
        
    }
    
    /*Method Name: getAgentList()
* Description: Agent list by using wrapper to dispaly the agent stats on page
* params: NA
* return type: List<AgentStatsWrapper>
*/
    public List<AgentStatsWrapper> getAgentList()
    {
        //Querying availabe Call center agents with PDI Profile
        Map<Id, User> availabeAgentsMap = new Map<Id, User>([SELECT Id, Name FROM USER WHERE Profile.Name = :Label.CL210_PDIAgentProfile AND isActive = true Order By Name LIMIT 1000]);
        showAgents = false; //To show the agents based on the existance
        if(!availabeAgentsMap.isEmpty())
        {
            showAgents = true;
        }
        getSelectedUsers();
        //Querying to get count of today open tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Count(OWNER.Name) recCount FROM Contact_Validation_Summary__c 
                                  WHERE  Age__c = 0 AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c IN (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status) 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() AND OWner.Type=:Label.CL212_PDIUser Group By Owner.Id LIMIT 1000])
        {
            
            if(res!=null)
            {
                //Mapping today open tickets by agent
                openTicketsCountMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)), 
                                        Integer.valueOf(res.get(Label.CL227_PDIOwnerCount))); 
                
            }
            
        }
        
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Count(Providers_By_Phone_Number__r.Owner.Name) recCount 
                                   FROM Contact_Validation_Summary__c WHERE Age__c = 0 AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c IN (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status) 
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000]){
                                       if(res1!=null)
                                       {
                                           //Mapping today open tickets by agent
                                           openTicketsCountMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)),Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
                                       }
                                   } 
        
        //Querying to get count of today closed tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Count(OWNER.Name) recCount FROM Contact_Validation_Summary__c 
                                  WHERE Age__c = 0 AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c = :Label.CL187_PDI_Validated_Status AND OWner.Type=:Label.CL212_PDIUser 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() Group By Owner.Id LIMIT 1000]){
                                      //Mapping today closed tickets by agent
                                      closedTicketsCountMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)),Integer.valueOf(res.get(Label.CL227_PDIOwnerCount)));
                                  }
        
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Count(Providers_By_Phone_Number__r.Owner.Name) recCount 
                                   FROM Contact_Validation_Summary__c WHERE Age__c = 0 AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c = :Label.CL187_PDI_Validated_Status 
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000]){
                                       if(res1!=null)
                                       {
                                           //Mapping today open tickets by agent
                                           closedTicketsCountMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)),Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
                                       }
                                   } 
        
        //Querying to get average resolution time of Today closed tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Avg(Resolution_Time_in_sec__C) recCount FROM Contact_Validation_Summary__c 
                                  WHERE Assigned_Date__c = Today AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c = :Label.CL187_PDI_Validated_Status AND OWner.Type=:Label.CL212_PDIUser 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() Group By Owner.Id  LIMIT 1000])
        {
            //Mapping today avg closed tickets resolution time by agent
            avgResTimeMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)), double.valueOf(res.get(Label.CL227_PDIOwnerCount)));
        }
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Avg(Resolution_Time_in_sec__C) recCount 
                                   FROM Contact_Validation_Summary__c WHERE Assigned_Date__c = Today AND PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c = :Label.CL187_PDI_Validated_Status 
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000]){
                                       if(res1!=null)
                                       {
                                           //Mapping today open tickets by agent
                                           avgResTimeMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)),Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
                                       }
                                   } 
        //Querying to get count of Campaign To Date open tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Count(OWNER.Name) recCount FROM Contact_Validation_Summary__c 
                                  WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c IN (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status) 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() AND OWner.Type=:Label.CL212_PDIUser Group By Owner.Id LIMIT 1000])
        {
            //Mapping campaign to date open tickets by agent
            campaignOpenTicketsCountMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)), 
                                            Integer.valueOf(res.get(Label.CL227_PDIOwnerCount)));
        }
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Count(Providers_By_Phone_Number__r.Owner.Name) recCount 
                                   FROM Contact_Validation_Summary__c WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c IN (:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status)  
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000]){
                                       if(res1!=null)
                                       {
                                           //Mapping today open tickets by agent
                                           campaignOpenTicketsCountMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)), Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
                                       }
                                   } 
        //Querying to get count of Campaign To Date closed tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Count(OWNER.Name) recCount FROM Contact_Validation_Summary__c 
                                  WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c = :Label.CL187_PDI_Validated_Status AND OWner.Type=:Label.CL212_PDIUser 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() Group By Owner.Id LIMIT 50000])
        {
            //Mapping campaign to date closed tickets by agent
            campaignClosedTicketsCountMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)), 
                                              Integer.valueOf(res.get(Label.CL227_PDIOwnerCount)));
        }
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Count(Providers_By_Phone_Number__r.Owner.Name) recCount 
                                   FROM Contact_Validation_Summary__c WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c = :Label.CL187_PDI_Validated_Status
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser
                                   Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000])
        {
            if(res1!=null)
            {
                //Mapping today open tickets by agent
                campaignClosedTicketsCountMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)),Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
            }
        } 
        
        //Querying to get average resolution time of Campaign To Date closed tickets group by agent
        for(AggregateResult res: [SELECT Owner.Id ownerId, Avg(Resolution_Time_in_sec__C) recCount 
                                  FROM Contact_Validation_Summary__c WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                  AND status__c = :Label.CL187_PDI_Validated_Status AND OWner.Type=:Label.CL212_PDIUser 
                                  AND Owner.Id IN: availabeAgentsMap.keySet() Group By Owner.Id LIMIT 50000])
        {
            //Mapping campaign to date avg closed tickets resolution time by agent
            campaignAvgResTimeMap.put(String.valueOf(res.get(Label.CL228_PDIOwnerId)), 
                                      double.valueOf(res.get(Label.CL227_PDIOwnerCount)));
        }
        for(AggregateResult res1: [SELECT Providers_By_Phone_Number__r.OwnerId, Avg(Resolution_Time_in_sec__C) recCount 
                                   FROM Contact_Validation_Summary__c WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name 
                                   AND status__c = :Label.CL187_PDI_Validated_Status
                                   AND Providers_By_Phone_Number__r.Owner.Id IN: selectedUsersMapCount.keySet() AND Providers_By_Phone_Number__r.OWner.Type=: Label.CL212_PDIUser Group By Providers_By_Phone_Number__r.OwnerId LIMIT 1000]){
                                       if(res1!=null)
                                       {
                                           //Mapping today open tickets by agent
                                           campaignAvgResTimeMap.put(String.valueOf(res1.get(Label.CL228_PDIOwnerId)), Integer.valueOf(res1.get(Label.CL227_PDIOwnerCount)));   
                                       }
                                   }
        
        //Constructing Wrapper list to show on the page
        agentStats = new List<AgentStatsWrapper>();   
        
        //Looping SOC agent users to bind the wrapper
        //uUsers = [SELECT ID, NAME FROM USER WHERE Profile.Name = :Label.CL210_PDIAgentProfile AND isActive = true Order By Name LIMIT 100];
        
        for(Id uId: availabeAgentsMap.keySet()) 
        {
            AgentStatsWrapper aws = new AgentStatsWrapper();
            aws.agent = availabeAgentsMap.get(uId);
            if(selectedUsersMap.containsKey(uId))
            {
                aws.isAssign = true; 
                aws.isPhoneAgent = false;
            }
            else if(selectedUsersMapCount.containsKey(uId))
            {
                aws.isAssign = true;
                aws.isPhoneAgent = true;
                
            }
            else {
                aws.isAssign = false;
            }
            
            if(openTicketsCountMap.containsKey(uId))
            {
                aws.todayOpen = openTicketsCountMap.get(uId);
            }
            else
            {
                aws.todayOpen = 0; 
            }
            if(closedTicketsCountMap.containsKey(uId))
            {
                aws.todayClosed = closedTicketsCountMap.get(uId);
            }
            else
            {
                aws.todayClosed = 0; 
            }
            if(avgResTimeMap.containsKey(uId))
            {
                if(avgResTimeMap.get(uId) != null)
                {
                    aws.todayAvg = avgResTimeMap.get(uId).intValue();
                }
            }
            else
            {
                aws.todayAvg = null; 
            }
            if(campaignOpenTicketsCountMap.containsKey(uId))
            {
                aws.campaignOpen = campaignOpenTicketsCountMap.get(uId);
            }
            else
            {
                aws.campaignOpen = 0; 
            }
            if(campaignClosedTicketsCountMap.containsKey(uId))
            {
                aws.campaignClosed = campaignClosedTicketsCountMap.get(uId);
            }
            else
            {
                aws.campaignClosed = 0; 
            }
            if(campaignAvgResTimeMap.containsKey(uId))
            {
                if(campaignAvgResTimeMap.get(uId) != null) 
                {
                    aws.campaignAvg = campaignAvgResTimeMap.get(uId).intValue();
                }
            }
            else
            {
                aws.campaignAvg = null; 
            }
            //WrapperList to show on the page
            agentStats.add(aws);
        }
        return agentStats;
    }
    
    /*Method Name: getSelectedUsers()
* Description: reusable method to get the selected users from custom settings object.
* params: NA
* return type: void
*/
    Public void getSelectedUsers()
    {
        selectedUsersMap.clear();
        selectedUsersMapCount.clear();
        //Getting selected agents from custom settings object
        List<PDISelectedAgents__c> selectedAgents = PDISelectedAgents__c.getall().values();
        if(selectedAgents != null)
        {
            for(PDISelectedAgents__c selectedagent: selectedAgents)
            {
                if(selectedagent.Phone_Agent__c){
                    selectedUsersMapCount.put(selectedAgent.Name, Integer.ValueOf(selectedAgent.Assigned_Count__c));
                }
                else{
                    selectedUsersMap.put(selectedAgent.Name, selectedAgent.Phone_Agent__c);
                }
            }
        }
    }
    /*Binding AssignBasedOn picklist from custom settings*/ 
    public List<SelectOption> getAssignBasedOn() {
        List<SelectOption> assignBasedOnOptions = new List<SelectOption>();
        PDIAutoAssignCriteria__c assignBasedOn = PDIAutoAssignCriteria__c.getInstance(Label.CL213_AutoAssignFieldValues);
        
        String[] assignList = assignBasedOn.Assign_Based_On__c.split(Label.CL231_PDISplitComma);
        for(String str: assignList)
        {
            String[] arr = str.split(Label.CL232_PDISplitColon);
            assignBasedOnOptions.add(new SelectOption(arr[0].trim(),arr[1].trim()));
        }
        return assignBasedOnOptions;
    }
    
    /*Binding SortingOrder picklist from custom settings  
*/ 
    public List<SelectOption> getSortingOrder() {
        
        PDIAutoAssignCriteria__c sortingOrder = PDIAutoAssignCriteria__c.getInstance(Label.CL213_AutoAssignFieldValues);
        List<SelectOption> sortingOptions = new List<SelectOption>();
        String[] sortList = SortingOrder.Sorting_Order__c.Split(Label.CL231_PDISplitComma);
        sortingOptions.add(new SelectOption(SortList[0],SortList[0])); 
        sortingOptions.add(new SelectOption(SortList[1],SortList[1]));
        return sortingOptions;
    }
    /*
Method Name: AssignToAgents
input Params: None
return type: void
Description: Action metohd to assign the records to agents based on the selected critieria
*/
    public void assign()
    {
        SystemException__c systemException = new SystemException__c();
        try
        {
            //Querying group to get the Non Validated Providers queue id
            Group que = [Select Id, name from group where type = 'queue' and Name =: Label.CL211_PDIQueue Limit 1];
            
            //Dynamic query to get the list of current campaign non validated records based on the filter criteria
            String query = 'SELECT Id, Owner.Id, Name, Assigned_Date__c, Closed_Date__c, PDI_Campaign__C, Retired_Departed__c, Provider_Active_Status__c, ' 
                +'Status__c, Provider_FirstName__c, Provider_LastName__c, Provider_NPI_F__c, Tech_Last_Verified_Date__c FROM Contact_Validation_Summary__c'
                +' WHERE OwnerId = \''+que.Id+'\' AND  PDI_Campaign__C = \''+Label.CL176_PDI_Current_Campaign_Name+'\' AND'
                +' Retired_Departed__c != true AND Provider_Active_Status__c = true AND '
                +' Status__c = \''+Label.CL185_PDI_Non_Validated_Status+'\' ORDER BY '+selectedAssignBasedOn+' '+selectedSortingOrder+ ' NULLS LAST LIMIT '+Label.CL380_PDIAssignQueryLimit+'';
            nonValidatedRecList = Database.query(query);  
            selectedUserIds.clear(); //Clearing selected users to reset the agents selection
            selectedUserPhoneIds.clear();
            
            //getting selected Agent ids into list
            sAgentsList = new List<PDISelectedAgents__c>();
            for(AgentStatsWrapper wAgent: agentListToDisplay) {
                PDISelectedAgents__c sAgent = new PDISelectedAgents__c();
                
                if(wAgent.isAssign && !wAgent.isPhoneAgent) {
                    selectedUserIds.add(wAgent.agent.Id);
                    sAgent.Name = wAgent.agent.Id;
                    sAgent.Phone_Agent__c = wAgent.isPhoneAgent;
                    sAgent.Assigned_Count__c = wAgent.campaignOpen;
                    sAgentsList.add(sAgent);
                }
                if(wAgent.isAssign && wAgent.isPhoneAgent){
                    sAgent.Name = wAgent.agent.Id;
                    sAgent.Phone_Agent__c = wAgent.isPhoneAgent;
                    sAgent.Assigned_Count__c = wAgent.campaignOpen;
                    sAgentsList.add(sAgent);
                    selectedUserPhoneIds.add(wAgent.agent.Id);
                }
            } 
            
            //Upserting selected PDI agents into custom settings object
            if(sAgentsList != null)
            {
                List<PDISelectedAgents__c> pdiSelectedAgents = [SELECT Id FROM PDISelectedAgents__c LIMIT 1000];
                delete pdiSelectedAgents;
                upsert sAgentsList name;
            }
            sAgentsList.clear();
            //Querying non validated phone number records 
            List<ProvidersByPhoneNumber__c> phoneRecords = new List<ProvidersByPhoneNumber__c>();
            //Querying duplicate queue id
            Group dupQue = [Select Id, name from group where type =: Label.CL411_PDIQueueAPI and Name =: Label.CL412_PDINonValidatedDuplicateQueue Limit 1];
            //Querying non validated duplicate phone number records
            phoneRecords = [SELECT Name, Tech_Phone_Number__c, NonValidatedCount__c, PDI_Campaign__c FROM ProvidersByPhoneNumber__c 
                            WHERE NonValidatedCount__c != 0 AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name AND OwnerId =: dupQue.Id LIMIT 10000];
            //Calling method to assign the records to agents
            assignDuplicateRecords(recordCount, phoneRecords);
            assignToAgents(recordCount, nonValidatedRecList);
            getPieData();
            agentListToDisplay = new List<AgentStatsWrapper>();
            agentListToDisplay = getAgentList();
            //Confirmation page message
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.CL192_PDIAutoAssignSuccess));
            //Updating selected filter criteria into custom settings object
            PDIAutoAssignSelectedCriteria__c pdiSelectedCriteria = PDIAutoAssignSelectedCriteria__c.getInstance(Label.CL201_AutoAssignSelectedCriteria);
            if(pdiSelectedCriteria == null)
            {
                pdiSelectedCriteria = new PDIAutoAssignSelectedCriteria__c();
                pdiSelectedCriteria.Name = Label.CL201_AutoAssignSelectedCriteria;
            }
            pdiSelectedCriteria.Record_Count_Per_Agent__c = recordCount;
            pdiSelectedCriteria.Assign_Based_On__c = selectedAssignBasedOn;
            pdiSelectedCriteria.Sorting_Order__c = selectedSortingOrder;
            Upsert pdiSelectedCriteria Name; //Upserting to insert or update the selected criteria
        }
        catch(Exception ex)
        {
            systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
        }
    }
    
    /*
Method Name: AssignToAgents
input Param1: recount count
input Param1: non validated providers list
return type: void
Description: Reusable method to assign the records to agents 
References: BatchAutoAssignRecordsToAgents
*/
    public void assignToAgents(Integer recordCount, List<Contact_Validation_Summary__c> nonValidatedRecList)
    {
        agentStats = null; // we need this line if we performed a write operation  because AgentList gets a fresh list now
        //Getting Active SOC agents list from users
        
        getSelectedUsers();
        //Getting existing count of records by agent
        AggregateResult[] arrUserCountList = [SELECT Owner.Id, Count(Id) recCount FROM Contact_Validation_Summary__c 
                                              WHERE PDI_Campaign__C = :Label.CL176_PDI_Current_Campaign_Name AND 
                                              owner.Id IN: (selectedUsersMap.keySet()) AND Status__c 
                                              IN(:Label.CL185_PDI_Non_Validated_Status, :Label.CL186_PDI_Accepted_Status) 
                                              Group By Owner.Id  LIMIT 1000];
        for(Id uId: selectedUsersMap.keySet())
        {
            if(!arrUserCountList.isEmpty())
            {
                for(AggregateResult arr: arrUserCountList)
                {
                    //Mapping users with count
                    if(String.ValueOf(arr.get(Label.CL229_PDIId)) == uId)
                    {
                        usersWithCountMap.put(String.ValueOf(arr.get(Label.CL229_PDIId)), Integer.ValueOf(arr.get(Label.CL227_PDIOwnerCount)));
                    }
                    else
                    {
                        if(!usersWithCountMap.containsKey(uId))
                        {
                            usersWithCountMap.put(uId, 0);   
                        }
                    }
                }
            }
            else
            {
                usersWithCountMap.put(uId, 0); //Initial Agent map with count of records
            }
        }
        //Assigning non validated records to agents based on the selected record count per agent
        Integer index = 0;
        for(Id uId: usersWithCountMap.keySet())
        {
            if(usersWithCountMap.get(uId) < recordCount){ 
                for(Integer i = usersWithCountMap.get(uId); i < recordCount; i++){ 
                    if(index < nonValidatedRecList.size())
                    {
                        nonValidatedRecList[index].OwnerId = uId;
                        nonValidatedRecList[index].Status__c = Label.CL186_PDI_Accepted_Status;
                        nonValidatedRecList[index].Assigned_Date__c = Datetime.now();  
                        recordsToUpdate.add(nonValidatedRecList[index]);
                        index = index + 1;
                    }
                }
                
            } 
            //Removing user from the map if the agent reached the assigned count
            usersWithCountMap.remove(uId);
        }
        if(!recordsToUpdate.isEmpty())
        {
            //Updating records owners with selected agents
            Database.update(recordsToUpdate);
            //Resetting Lists after successfull update
            selectedUsersMap.clear();
            arrUserCountList.clear();
            recordsToUpdate.clear(); 
            //sAgentsList.clear();
            usersWithCountMap.clear();
        }
    }
    /*
Method Name: assginDuplicateRecords
input Param1: recount count
input Param1: non validated providers list
return type: void
Description: Reusable method to assign the duplicate phone number records to agents 
References: BatchAutoAssignRecordsToAgents
*/
    public void assignDuplicateRecords(Integer recordCount, List<ProvidersByPhoneNumber__c> phoneRecords){
        getSelectedUsers();
        List<ProvidersByPhoneNumber__c> phoneRecordsToUpdate = new List<ProvidersByPhoneNumber__c>();
        //Querying group to get the duplicate phone queue id
        
        Set<Id> assigned = new Set<Id>();
        for(String uId: selectedUsersMapCount.keySet()){
            for(ProvidersByPhoneNumber__c phoneRec: phoneRecords){
                if(selectedUsersMapCount.get(uId) < recordCount)
                {
                    if(!assigned.contains(phoneRec.Id))
                    {
                        phoneRec.OwnerId = uId;
                        Integer count = Integer.ValueOf(selectedUsersMapCount.get(uId)) + Integer.ValueOf(phoneRec.NonValidatedCount__c);
                        phoneRecordsToUpdate.add(phoneRec);
                        assigned.add(phoneRec.Id);
                        selectedUsersMapCount.put(uId, count);
                    }
                }
                else
                {
                    selectedUsersMapCount.remove(uId);
                }
            }
            
        }
        Database.update(phoneRecordsToUpdate);
    }
    
    /*Method Name: getPieData()
* Description: to display the records status into report
* params: NA
* return type: List<PieWedgeData>
*/
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        String query = 'Select Tech_Validation_Status__c, Count(id) reccount From Contact_Validation_Summary__c ' 
            +' Where Tech_Validation_Status__c != null AND Status__c != \''+Label.CL186_PDI_Accepted_Status+'\' AND PDI_Campaign__c = \''+Label.CL176_PDI_Current_Campaign_Name+'\' ' 
            +' group by  Tech_Validation_Status__c';
        for(AggregateResult arr : Database.query(query)){
            data.add(new PieWedgeData(String.valueOf(arr.get(Label.CL365_TechValidationStatus)), Integer.valueOf(arr.get(Label.CL366_ChartRecCount)))); 
        }
        return data;
    }
    
    // Wrapper class to construct report params
    public class PieWedgeData {
        public String name { get; set; }
        public Integer data { get; set; }
        
        /*Constructor to initialize the wrapper
*/
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }
    
    /*Wrapper class to bind the agents tickets status*/
    Public with sharing class AgentStatsWrapper
    {
        public User agent{get;set;}
        public Boolean isAssign{get;set;}
        public Boolean isPhoneAgent{get; set;}
        public Integer todayOpen{get;set;}
        public Integer todayClosed{get;set;}
        public Integer todayAvg{get;set;}
        public Integer campaignOpen {get;set;}
        public Integer campaignClosed{get;set;}
        public Integer campaignAvg{get;set;}
    }
    
}