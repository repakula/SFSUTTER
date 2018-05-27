/**  
*     Class Name: ManageUserPermissions
*     Author: Brandon Cassis
*     Date: 12-July-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This is a helper class for the trigger 'ManageContacts'. This class contains methods to assign permission sets 
*     to new Users and manage the permission sets for the existing Users. 
*
*    History
*    --------
*
*    VERSION    AUTHOR          DATE                 DETAIL
*       1.0     IDC Offshore   31/07/2013       Added Comments and Indentation
*       2.0     IDC Offshore   21/04/2014       Req2978 Release5 Bargaining Unit Changes
**/
public without sharing class ManageUserPermissions{


    /** @Description: Empty Constructor.**/
    public ManageUserPermissions() {}

    /** @Description: List variable to store Permission set field values**/
    public static List<PermissionSetFields__c> permissionFields = PermissionSetFields__c.getAll().values();
    
    /** @Description: Map variables used all over the class**/
    public static Map<String, String> unionPermissions = new Map<String, String>();
   
    /** @Description:Req2978 R5 Bargaining Unit Changes(Adding bargainingPermission Map variables).**/
    public static Map<String, String> bargainingPermissions = new Map<String, String>();
    public static Map<String, String> benefitPermissions = new Map<String, String>();
    public static Map<String, String> affiliatePermissions = new Map<String, String>();
    
    /**
    *   @Description: This method deletes the permission set assigned to Users
    *   @Arguments: Set of User Id      
    *   @Return: Void
    *   @Exception: This method call is to accept the exception string build out of details about 
    *    the exception and stores that exception in a custom object that can be reported on. This call does
    *    not follow standards for line length to increase test code coverage.
    *    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
    **/
    public static void setNewlyUnactiveUserPermissions(Set<Id> userIdList) {
        List<PermissionSetAssignment> deleteListPSA = new List<PermissionSetAssignment>();
        
        try{
            
            /** 
            *    @Desription: Query on Permission Set Assignments table and returning Id, AssignedId, PermissionSetId and PermissionSet.IsOwnedByProfile  
            *    based on provided user list and where PermissionSet.IsOwnedByProfile = false, storing the result set in list. 
            **/
            deleteListPSA = [select Id, AssigneeId, PermissionSetId, PermissionSet.IsOwnedByProfile from PermissionSetAssignment where AssigneeId IN :userIdList AND PermissionSet.IsOwnedByProfile = false];
            if(!deleteListPSA.isEmpty()) {
                
                /** @Description: Iterate over list of permission set assignments**/
                for(PermissionSetAssignment psa: deleteListPSA) {
                    system.debug('psa.AssigneeId' +psa.AssigneeId);
                    system.debug('psa.PermissionSetId' +psa.PermissionSetId);
                }
                system.debug('@@deleteListPSA :' + deleteListPSA);
                /** @Description: Validate the list of Permission set assignment is not empty**/
                if(!deleteListPSA.isEmpty()) {
                    
                    /** @Description: Delete Permission set Assignments**/
                    delete deleteListPSA;
                }
            }
        } catch(Exception classException) {
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       }  
    }
    
    /**
    *   @Description: This method manages the permission set assignments for existing Users
    *   @Arguments: List of Id, List of Id, List of Id, Map of Id and String, Map of Id and String, Map of Id and String, Map of Id and String      
    *   @Return: Void
    *   @Exception: This method call is to accept the exception string build out of details about 
    *    the exception and stores that exception in a custom object that can be reported on. This call does
    *    not follow standards for line length to increase test code coverage.
    *    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
    **/
    public static void setCurrentUserPermissions(List<Id> noChangeUserIds, List<Id> deactivatedUsers, List<Id> reactivatedUsers, 
                                                        Map<Id, String> unionMap, Map<Id, String> bargainingMap,  Map<Id, String> benefitMap, Map<Id, String> affiliateMap,Map<Id, String> EEOsubcodeMap,Map<Id, String> CompanycodeMap,Map<Id, String> ProcesslevelMap) {
        
        Id managerProfileId = [SELECT Id FROM Profile WHERE Name =:system.label.CL30_Community_Portal_Manager].id;
        List<PermissionSet> permissionsetList = [Select Id, Name from PermissionSet where Name =:system.label.CL29_ManagerArticles];
        /** Req 3676 **/
        List<PermissionSet> permissionsetList02 = [Select Id, Name from PermissionSet where Name =:system.label.CL157_ManagerArticles];
        List<PermissionSet> permissionsetList04 = [Select Id, Name from PermissionSet where Name =:system.label.CL158_ManagerArticles];
        
        /** @Description: Set of successful PSA ids **/
        Set<Id> successPSAIds = new Set<Id>();
        
        /** @Description: Maps to contain Assignee Id to PSA **/
        Map<Id, PermissionSetAssignment> allIdPSAMap = new Map<Id, PermissionSetAssignment>();
        Map<Id, PermissionSetAssignment> successIdPSAMap = new Map<Id, PermissionSetAssignment>();
        
        /** @Description: List of successful and failed PSA **/
        List<PermissionSetAssignment> successPSAList = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> failedPSAList = new List<PermissionSetAssignment>();
        String emailString = '';
        Boolean isUpsertfirstTime = true;
        
        /** @Description: Set variables**/
        Set<Id> deletePSAUsers = new Set<Id>();  
        Set<Id> addPSAUsers = new Set<Id>();
        Set<String> soqlPermissionSet = new Set<String>();
        Set<Id> updateUserIds = new Set<Id>();
        
        /** @Description: Map variables to store Id and String**/
        Map<Id, String> addUserUnionPermissionSetMap = new Map<Id, String>();
        
        /**@Description:Req2978 R5 Bargaining Unit Changes(Added bargainingPermissionSetMap).**/
        Map<Id, String> addUserBargainingPermissionSetMap= new Map<Id, String>();
        Map<Id, String> addUserBenefitPermissionSetMap = new Map<Id, String>();
        Map<Id, String> addUserAffiliatePermissionSetMap = new Map<Id, String>();
        
        /** @Description: List variable to store PermissionSetAssignment**/
        List<PermissionSetAssignment> createPSAs = new List<PermissionSetAssignment>();
        
        Map<String, Id> permissionSetMap;
                                                   
        /** @Description: Add user Ids to sets**/
        deletePSAUsers.addAll(noChangeUserIds); 
        deletePSAUsers.addAll(deactivatedUsers);                                            
        addPSAUsers.addAll(noChangeUserIds); 
        addPSAUsers.addAll(reactivatedUsers); 
        
        if(!(ManageExecutions.isSameExecution)) {
            
            /** @Description: Method call to set permissions for different fields**/
            setPermissionMaps();
            ManageExecutions.setSameExecution();
            System.Debug('permission 2'); 
        }
       
        /** @Description: Iterate over set**/
        for(Id loopId: addPSAUsers) {
            system.debug('UnionMap: '+ unionMap.get(loopId) );
            system.debug('unionPermissions.get(unionMap.get(loopId))' + unionPermissions.get(unionMap.get(loopId)) );
            
            /** @Description: If the union map value for this user is present as a key in unionPermissions**/
            if(unionPermissions.containsKey(unionMap.get(loopId))) {
                
                /** @Description: Populate the map with user id and unionPermission value**/
                addUserUnionPermissionSetMap.put(loopId, unionPermissions.get(unionMap.get(loopId)));
            }
            
            /**@Description:Req2978 R5 Bargaining Unit Changes(If the bargaining map value for this user is present as a key in bargainingPermissions).**/
            if(bargainingpermissions.containsKey (bargainingMap.get(loopId))) {
            
                /**@Description:Req2978 R5 Bargaining Unit Changes(Populate the map with user id and bargainingPermissions value).**/
                addUserBargainingPermissionSetMap.put(loopId, bargainingPermissions.get(bargainingMap.get(loopId)));
                }
                                  
            system.debug('BenefitMap: '+ benefitMap.get(loopId) );
            system.debug('BenefitPermissions.get(benefitMap.get(loopId))' + benefitPermissions.get(benefitMap.get(loopId)) );
           
            /** @Description: If the benefit map value for this user is present as a key in benefitPermissions**/
            if(benefitPermissions.containsKey(benefitMap.get(loopId))) {
                
                /** @Description: Populate the map with user id and benefitPermission value**/
                addUserBenefitPermissionSetMap.put(loopId, benefitPermissions.get(benefitMap.get(loopId)));
            }
            system.debug('AffiliateMap: '+ affiliateMap.get(loopId) );
            system.debug('AffiliatePermissions.get(affilaiteMap.get(loopId))' + affiliatePermissions.get(affiliateMap.get(loopId)) );
           
            /** @Description: If the benefit map value for this user is present as a key in affiliatePermissions**/
            if(affiliatePermissions.containsKey(affiliateMap.get(loopId))) {
                
                /** @Description: Populate the map with user id and affiliatePermission value**/
                addUserAffiliatePermissionSetMap.put(loopId, affiliatePermissions.get(affiliateMap.get(loopId)));
            }
        } 
        
        /** @Description: Add the values from the maps to Set**/
        soqlPermissionSet.addAll(addUserUnionPermissionSetMap.values());
     
        /**@Description:Req2978 R5 Bargaining Unit Changes(Added the bargaining permission values from map to set).**/
        soqlPermissionSet.addAll(addUserBargainingPermissionSetMap.values());
        soqlPermissionSet.addAll(addUserBenefitPermissionSetMap.values());
        soqlPermissionSet.addAll(addUserAffiliatePermissionSetMap.values()); 
        updateUserIds.addAll(addUserUnionPermissionSetMap.keySet());
      
        /**@Description:Req2978 R5 Bargaining Unit Changes(Added the bargaining permission values from map to set).**/
        updateuserIds.addAll (addUserBargainingPermissionSetMap.keySet());
        updateUserIds.addAll(addUserBenefitPermissionSetMap.keySet());
        updateUserIds.addAll(addUserAffiliatePermissionSetMap.keySet());                                      
        system.debug('soqlPermissionSet size' + soqlPermissionSet.size());
        
        if(!soqlPermissionSet.isEmpty()) {
            
            /** @Description: method call to create a map of permission set name and permission set Id**/ 
            permissionSetMap = getPermissionIdMap(soqlPermissionSet);
        }
         //system.debug('permissionSetMap size' + permissionSetMap.size());
        system.debug('@@updateUserIds :'+updateUserIds);
        /** @Description: Iterate over set of user Ids**/
        for(Id loopId: updateUserIds) {
            
            /** @Description: If the addUserUnionPermissionSetMap contains User Id and permissionSetMap contains the name of the permission set indicated by the addUserUnionPermissionSetMap**/
            if(addUserUnionPermissionSetMap.containsKey(loopId) && addUserBargainingPermissionSetMap.get(loopId) == null && permissionSetMap.containsKey(addUserUnionPermissionSetMap.get(loopId))) {
                
                /** @Description: method call to create an instance of permission set assignment for User and Permission set and added to list**/
                createPSAs.add(createPermissionSetAssignment(loopId, permissionSetMap.get(addUserUnionPermissionSetMap.get(loopId))));
            }
            
            
            /**@Description:Req2978 R5 Bargaining Unit Changes(If the addUserUnionPermissionSetMap contains User Id and permissionSetMap contains the name of the permission set indicated by the addUserBargainingPermissionSetMap).**/
            if(addUserBargainingPermissionSetMap.containsKey(loopId) && addUserBargainingPermissionSetMap.get(loopId) <> null && permissionSetmap.containsKey(addUserBargainingPermissionSetMap.get(loopId))) {
            
                 /**@Description:Req2978 R5 Bargaining Unit Changes(method call to create an instance of permission set assignment for User and Permission set and added to list).**/
                 createPSAs.add(createPermissionSetAssignment(loopId, permissionSetmap.get (addUserBargainingPermissionSetMap.get(loopId))));
            }
                        
            
            /** @Description: If the addUserBenefitPermissionSetMap contains User Id and permissionSetMap contains the name of the permission set indicated by the addUserBenefitPermissionSetMap**/
            if(addUserBenefitPermissionSetMap.containsKey(loopId) && permissionSetMap.containsKey(addUserBenefitPermissionSetMap.get(loopId))) {
                
                /** @Description: method call to create an instance of permission set assignment for User and Permission set and added to list**/
                createPSAs.add(createPermissionSetAssignment(loopId, permissionSetMap.get(addUserBenefitPermissionSetMap.get(loopId))));
            }
            
            /** @Description: If the addUserAffiliatePermissionSetMap contains User Id and permissionSetMap contains the name of the permission set indicated by the addUserAffiliatePermissionSetMap**/
            if(addUserAffiliatePermissionSetMap.containsKey(loopId) && permissionSetMap.containsKey(addUserAffiliatePermissionSetMap.get(loopId))) {
                
                /** @Description: method call to create an instance of permission set assignment for User and Permission set and added to list**/
                createPSAs.add(createPermissionSetAssignment(loopId, permissionSetMap.get(addUserAffiliatePermissionSetMap.get(loopId))));
            }
        }  
        system.debug('createPSAs size' + createPSAs.size());
        try{
            if(!deletePSAUsers.isEmpty()) {
                
                /** @Description: Method call to delete existing permission set assignment for users**/
                setNewlyUnactiveUserPermissions(deletePSAUsers);
                system.debug('should be before');
            }
        } catch(Exception classException) {   
           
        Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       }
        
        List<User> userManageList = [Select Id, ProfileId from User where Id IN : addPSAUsers];
        
        for(User user : userManageList){
            if(user.ProfileId == managerProfileId && EEOsubcodeMap.get(user.Id) != '0'){
                PermissionSetAssignment permAssign = new PermissionSetAssignment();
                //Req 3676
                If (EEOsubcodeMap.get(user.Id) == '1' || EEOsubcodeMap.get(user.Id) == 'blank' ){
                    permAssign.PermissionSetId = permissionsetList[0].id;              
                }
                else If( CompanycodeMap.get(user.Id) == '470' && ProcesslevelMap.get(user.Id) == '99'){
                    permAssign.PermissionSetId = permissionsetList04[0].id; 
                }
                else{
                    permAssign.PermissionSetId = permissionsetList02[0].id;
                }
                           
                permAssign.AssigneeId = user.id;
                createPSAs.add(permAssign);
            }
        }
        try{
            system.debug('@@createPSAs :'+createPSAs);
            if(!createPSAs.isEmpty()) {
                
                List<PermissionSetAssignment> filteredPSA = new List<PermissionSetAssignment>();
                
                for(PermissionSetAssignment psa:createPSAs)
                {
                    if(psa.AssigneeId <> null && psa.PermissionSetId <> null)
                    {
                        filteredPSA.add(psa);
                    }
                }
                
                /** @Description: insert permission set assignments**/
                Database.UpsertResult[] srList = Database.upsert(filteredPSA, false);
                
                set<string> successPSAId = new set<string>();
                List<PermissionSetAssignment> failurePSAList = new List<PermissionSetAssignment>();
                set<string> successPSASet = new set<string>();
                
                for(Database.UpsertResult sr:srList)
                {
                    if(sr.isSuccess())
                    {
                        successPSAId.add(sr.getId());
                    }
                    else {
                    // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Upsert PSA catch Block :: The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Upsert PSA : PSA fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                
                for(PermissionSetAssignment PSA:[Select PermissionSetId, Id, AssigneeId From PermissionSetAssignment where Id IN :successPSAId])
                {
                    successPSASet.add(PSA.AssigneeId+'#'+PSA.PermissionSetId);
                }
                
                for(PermissionSetAssignment PSA : createPSAs)
                {
                    if(!successPSASet.contains(PSA.AssigneeId+'#'+PSA.PermissionSetId))
                    {
                        failurePSAList.add(PSA);
                    }
                }
                
                if(!failurePSAList.isEmpty())
                {
                    Database.UpsertResult[] upsertList = Database.upsert(failurePSAList, false);
                    
                    set<string> successPSASet2 = new set<string>();
                    List<PermissionSetAssignment> failurePSAList2 = new List<PermissionSetAssignment>();
                        
                    /** @Description: Iterate over upsertList to get successfully inserted PSA Ids **/
                    for(Database.Upsertresult upResult : upsertList){
                        if(upResult.isSuccess()){
                            successPSAIds.add(upResult.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : upResult.getErrors()) {
                                System.debug('Upsert PSA catch Block :: The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Upsert PSA : PSA fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                    
                    for(PermissionSetAssignment PSA:[Select PermissionSetId, Id, AssigneeId From PermissionSetAssignment where Id IN :successPSAIds])
                    {
                        successPSASet2.add(PSA.AssigneeId+'#'+PSA.PermissionSetId);
                    }
                    
                    for(PermissionSetAssignment PSA : failurePSAList)
                    {
                        if(!successPSASet2.contains(PSA.AssigneeId+'#'+PSA.PermissionSetId))
                        {
                            failurePSAList2.add(PSA);
                        }
                    }
                    
                    if(!failurePSAList2.isEmpty())
                    {
                        for(PermissionSetAssignment psa : failurePSAList2){
                            emailString = emailString + '##AssigneeId :' + psa.AssigneeId + '@@PermissionSetId :' + psa.PermissionSetId + '\r\n';
                        }
                        Utility.sendErrorEmail('###Failed PSAs to Insert ::  '+ emailString);
                    }
                }
                    
                system.debug('should be after');
            }
            
        } catch(Exception classException) {
            system.debug('@@begin :'+ classException.getMessage() + 'break1\r\n' + classException.getStackTraceString() + 'break2\r\n' + classException.getTypeName() + 'break3\r\n' + System.now() + 'break4\r\n' + '--------------'); 
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       }                                      
    }
    
    /**
    *   @Description: This method manages the permission set assignments for new users.
    *   @Arguments: List of String, List of String, List of String, List of String, List of String, List of String, 
    *   List of String, List of String, List of String, List of String, string  
    *   @Return: Void
    *   @Exception: This method call is to accept the exception string build out of details about 
    *    the exception and stores that exception in a custom object that can be reported on. This call does
    *    not follow standards for line length to increase test code coverage.
    *    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
    **/
    public static void setNewUserPermissions(List<User> userList, Map<Id, String> unionMap, Map<Id, String> bargainingMap, Map<Id, String> benefitMap, Map<Id, String> affiliateMap,Map<Id, String> EEOsubcodeMap,Map<Id, String> CompanycodeMap,Map<Id, String> ProcesslevelMap) {
    
        Id managerProfileId = [SELECT Id FROM Profile WHERE Name =:system.label.CL30_Community_Portal_Manager].id;
        List<PermissionSet> permissionsetList = [Select Id, Name from PermissionSet where Name =:system.label.CL29_ManagerArticles];
        /** Req 3676 **/
        List<PermissionSet> permissionsetList02 = [Select Id, Name from PermissionSet where Name =:system.label.CL157_ManagerArticles];
        List<PermissionSet> permissionsetList04 = [Select Id, Name from PermissionSet where Name =:system.label.CL158_ManagerArticles];
        
        Set<Id> successPSAIds = new Set<Id>();
        Map<Id, PermissionSetAssignment> allIdPSAMap = new Map<Id, PermissionSetAssignment>();
        Map<Id, PermissionSetAssignment> successIdPSAMap = new Map<Id, PermissionSetAssignment>();
        
        List<PermissionSetAssignment> successPSAList = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> failedPSAList = new List<PermissionSetAssignment>();
        String emailString ='';
        /** @Description: Set of all, successful and failed PSA Ids**/
        Set<Id> allPSAIds = new Set<Id>();
        Set<Id> successfulPSAIds = new Set<Id>();
        Set<Id> failedPSAIds = new Set<Id>();
        
        Set<String> permissionSetSOQL = new Set<String>();
        List<PermissionSetAssignment> insertAssignments = new List<PermissionSetAssignment>();

         System.Debug('permission 11'); 
         if(!(ManageExecutions.isSameExecution)) {
             
            /** @Description: Method call to set permissions for different fields**/
            setPermissionMaps();
             ManageExecutions.setSameExecution();
         }
         
         /** @description: Iterate over User list**/
         for(User loopUser: userList) {
            system.debug('@@unionMap :'+unionMap);
             /** @Description: Populate maps and sets**/
             if(unionMap.get(loopUser.Id) <> 'blank'){
                system.debug('inside null check union');
                 permissionSetSOQL.add(unionPermissions.get(unionMap.get(loopUser.Id))); 
                 unionPermissions.put(loopUser.Id, unionPermissions.get(unionMap.get(loopUser.Id)));  
             }
             
             permissionSetSOQL.add(bargainingPermissions.get(bargainingMap.get(loopUser.Id)));
             
             /**@Description:Req2978 R5 Bargaining Unit Changes(Populating bargaining permission sets and map).**/
             bargainingPermissions.put(loopuser.Id,bargainingpermissions.get(bargainingMap.get(loopUser.Id)));
             permissionSetSOQL.add(benefitPermissions.get(benefitMap.get(loopUser.Id)));
             benefitPermissions.put(loopUser.Id, benefitPermissions.get(benefitMap.get(loopUser.Id)));
             permissionSetSOQL.add(affiliatePermissions.get(affiliateMap.get(loopUser.Id)));
             affiliatePermissions.put(loopUser.Id, affiliatePermissions.get(affiliateMap.get(loopUser.Id)));
         }
             system.debug('@@permissionSetSOQL :'+permissionSetSOQL);
            /** @Description: Method call to create a map of permission set name and permission set Id**/ 
            Map<String, Id> permissionSetIdsMap = getPermissionIdMap(permissionSetSOQL);
             
            System.Debug('permission 12'); 
            
            /** @Description: Iterate over User List**/
         for(User loopUser: userList) {
             
             /** @Description: Method call to create an instance of permission set assignment for User and Permission set and add them to the list**/
             System.Debug('@@unionPermissions :'+ unionPermissions); 
             if(unionMap.get(loopUser.Id) <> 'blank'){
                
                 /**@Description:Req2978 R5 Bargaining Unit Changes(Null Check for bargaining permission set).**/
                if(bargainingPermissions.get(loopUser.Id) == null)
                {
                    insertAssignments.add(createPermissionSetAssignment(loopUser.Id, permissionSetIdsMap.get(unionPermissions.get(loopUser.Id))));
                }
             }
             
             if(bargainingPermissions.get(loopUser.Id) <> null)
             {
                insertAssignments.add(createPermissionSetAssignment(loopUser.ID, permissionSetIdsMap.get(bargainingPermissions.get(loopUser.Id))));
             }
             
             
             
             system.debug('permissionSetIdsMap.get(unionPermissions.get(loopUser.Id))' +permissionSetIdsMap.get(unionPermissions.get(loopUser.Id)));
            
             /** @Description: Method call to create an instance of permission set assignment for User and Permission set and add them to the list**/
             insertAssignments.add(createPermissionSetAssignment(loopUser.Id, permissionSetIdsMap.get(benefitPermissions.get(loopUser.Id))));
             system.debug('permissionSetIdsMap.get(benefitPermissions.get(loopUser.Id))' +permissionSetIdsMap.get(benefitPermissions.get(loopUser.Id)));
             
             /** @Description: Method call to create an instance of permission set assignment for User and Permission set and add them to the list**/
             insertAssignments.add(createPermissionSetAssignment(loopUser.Id, permissionSetIdsMap.get(affiliatePermissions.get(loopUser.Id))));
             system.debug('permissionSetIdsMap.get(affiliatePermissions.get(loopUser.Id))' +permissionSetIdsMap.get(affiliatePermissions.get(loopUser.Id)));
            
            system.debug('@@insertAssing before manage articles:'+insertAssignments);
            
            //Apoorv 28/11
            
            if(loopUser.ProfileId == managerProfileId && EEOsubcodeMap.get(loopUser.Id) != '0'){
                PermissionSetAssignment permAssign = new PermissionSetAssignment();
                //Req 3676
                System.Debug('@@@EEOsubcodeMap.get(loopUser.Id)' + EEOsubcodeMap.get(loopUser.Id));
                System.Debug('@@@EEOsubcodeMap.get(loopUser.Id)' + CompanycodeMap.get(loopUser.Id));
                System.Debug('@@@EEOsubcodeMap.get(loopUser.Id)' + ProcesslevelMap.get(loopUser.Id) );
                If (EEOsubcodeMap.get(loopUser.Id) == '1' || EEOsubcodeMap.get(loopUser.Id) == 'blank'){
                     permAssign.PermissionSetId = permissionsetList[0].id;              
                }
                else If(CompanycodeMap.get(loopUser.Id) == '470' && ProcesslevelMap.get(loopUser.Id) == '99'){
                     permAssign.PermissionSetId = permissionsetList04[0].id; 
                }
                else{
                     permAssign.PermissionSetId = permissionsetList02[0].id;
                }
                    
                permAssign.AssigneeId = loopUser.id;
                insertAssignments.add(permAssign);
            }
         }
         system.debug('@@insertAssing after manage articles:'+insertAssignments);
        try{
            
            /** @Description: Add all Insert PSA Ids in Set **/
            for(PermissionSetAssignment psAssign : insertAssignments){
                allIdPSAMap.put(psAssign.AssigneeId, psAssign); 
            }
            
            system.debug('This is my insert list size: '+ insertAssignments.size());
            if(!insertAssignments.isEmpty()) {
                
                List<PermissionSetAssignment> filteredPSA = new List<PermissionSetAssignment>();
                
                for(PermissionSetAssignment psa:insertAssignments)
                {
                    if(psa.AssigneeId <> null && psa.PermissionSetId <> null)
                    {
                        filteredPSA.add(psa);
                    }
                }
                
                /** @Description: insert permission set assignments and add to SaveResult List **/
                Database.SaveResult[] srPSA = Database.insert(filteredPSA, false);
                
                /** @Description: Iterate over SaveResult List to store successfully inserted PSA Ids **/
                for(Database.SaveResult sr : srPSA){
                    if(sr.isSuccess()){
                        successPSAIds.add(sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Insert User : PSA insert :: The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Inser User : PSA insert fields that affected this error: ' + err.getFields());
                        }
                    }
                    
                }
                
                /** @Description: SOQL successfully inserted PSA **/
                successPSAList = [Select Id, AssigneeId, PermissionSetId from PermissionSetAssignment where Id IN : successPSAIds];
                
                /** @Description: Iterate over inserted PSA to create Map of Assignee Id and PSA **/
                for(PermissionSetAssignment psa : successPSAList){
                    successIdPSAMap.put(psa.AssigneeId, psa);
                }
                
                /** @Description: Iterate over values of All PSA Maps and compare all PSA to successfully inserted PSA to get a list of failed PSAs **/
                for(PermissionSetAssignment psa : allIdPSAMap.values()){
                    if(successIdPSAMap.get(psa.AssigneeId) != psa){
                        failedPSAList.add(psa);
                    }
                }
                system.debug('@@failed PSA :: '+failedPSAList);
                /** @Description: Send out email if failedPSAList is not empty **/
                if(!failedPSAList.isEmpty()){
                    for(PermissionSetAssignment psa : failedPSAList){
                        emailString = emailString + '##AssigneeId :' + psa.AssigneeId + '@@PermissionSetId :' + psa.PermissionSetId + '\r\n';
                    }
                    Utility.sendErrorEmail('###Failed PSAs to Insert ::  '+ emailString);
                }
            }
            
            System.Debug('permission 13'); 
        } catch(Exception classException) {   
          
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       }    
  }

    /**
    *   @Description: This method returns a map of permission set name and permission set ID
    *   @Arguments: set of string
    *   @Return: Map of string and Id
    *   @Exception: This method call is to accept the exception string build out of details about 
    *    the exception and stores that exception in a custom object that can be reported on. This call does
    *    not follow standards for line length to increase test code coverage.
    *    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
    **/
    public static Map<String, Id> getPermissionIdMap(Set<String> permissionNames) {
        
        /** @Description: List variable to store permission set**/
        List<PermissionSet> permissionSetResults = new List<PermissionSet>();
        
        /** @Description: Map variable to store name and ID of the permission set**/
        Map<String, Id> returnValue = new Map<String, Id>();
        try {
        system.debug('Is this my error?before soql');
        
            /** @Description: Query the permission set**/
            permissionSetResults = [select Id, Name from PermissionSet where Name IN :permissionNames AND IsOwnedByProfile = false];
            system.debug('@@permission Results :'+permissionSetResults);
            system.debug('Is this my error?after soql');
            System.Debug('permission 14'); 
        } catch(Exception classException) {    
           Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
           Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
       }
        System.Debug('permission 15'); 
        
        /** @Description: Iterate over list of permission sets**/
        for(PermissionSet loopPermissionSet: permissionSetResults) {
            
            /** @Description: Populate the map with permission set name and Id **/
            returnValue.put(loopPermissionSet.Name, loopPermissionSet.Id);
            System.Debug('permission 16'); 
        }
        
        /** @Description: return the Map**/
        return returnValue;
    } 
    
    /**
    *   @Description: This method sets the permission Maps for various Contact fields
    *   @Return: Void
    **/
    public static void setPermissionMaps() {
        
        /** @Description: Iterate over the PermissionSetFields list**/
        for(PermissionSetFields__c loopPermission: permissionFields) {
            System.Debug('permission 17'); 
            
            /** @Description: If the FieldAPIName__c is EMPLOYEE_UNION_AFFILIATE__C**/
            if(loopPermission.FieldAPIName__c == 'EMPLOYEE_UNION_AFFILIATE__C') {
                
                /** @Description: Populate unionPermissions map with FieldValue__c and Name**/
                unionPermissions.put(loopPermission.FieldValue__c, loopPermission.Name);
            } 
            
            /**@Description:Req2978 R5 Bargaining Unit Changes(If the FieldAPIName__c is EMPLOYEE_BARGAINING_UNION__C).**/
            if(loopPermission.FieldAPIName__c == 'EMPLOYEE_BARGAINING_UNION__C') {
            
                /**@Description:Req2978 R5 Bargaining Unit Changes(Populate bargainingPermissions map with FieldValue__c and Name).**/
                bargainingPermissions.put(loopPermission.FieldValue__c, loopPermission.Name);
                }
                
            /** @Description: If the FieldAPIName__c is EMPLOYEE_EMPLOYMENT_STATUS__C**/
            else if(loopPermission.FieldAPIName__c == 'EMPLOYEE_EMPLOYMENT_STATUS__C') {
                
                /** @Description: Populate benefitPermissions map with FieldValue__c and Name**/
                benefitPermissions.put(loopPermission.FieldValue__c, loopPermission.Name);
            }
            /** @Description: If the FieldAPIName__c is EMPLOYEE_AFFILIATE_FACILITY__C**/
            else if(loopPermission.FieldAPIName__c == 'EMPLOYEE_AFFILIATE_FACILITY__C') {
                
                /** @Description: Populate affiliatePermissions map with FieldValue__c and Name**/
                affiliatePermissions.put(loopPermission.FieldValue__c, loopPermission.Name);
                System.Debug('permission 18'); 
            }
        }
    }
    
    /**
    *   @Description: This method sets values in PermissionSet and return back.
    *   @Arguments: User Id, PermissionSet Id
    *   @Return: PermissionSetAssignment
    **/
    public static PermissionSetAssignment createPermissionSetAssignment(Id userId, Id permissionSetId) {
        PermissionSetAssignment returnValue = new PermissionSetAssignment();
        
        /** @Description: Assign values to PermissionSetAssignment instance**/
        returnValue.PermissionSetId = permissionSetId;
        returnValue.AssigneeId = userId;
        System.Debug('permission 19'); 
        
        /** @Description: return PermissionSetAssignment**/
        return returnValue;
    }
    
    /**
    *   @Description: This method returns a System Administrator User
    *   @Return: User
    **/
    public static User getExceptionUser() { 
        
        /** @Description: Query and Return an active user with System Administrator Profile**/
        return [select id, profile.name, IsActive from user where profile.name = 'system administrator' AND IsActive = true limit 1];   
    }
}