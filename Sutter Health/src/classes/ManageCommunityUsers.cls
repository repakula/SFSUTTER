/**  
*     Class Name: ManageCommunityUsers
*     Author: Brandon Cassis
*     Date: 15-July-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description: This is a helper class for the trigger 'ManageContacts'. This class contains the methods to create new users
*     and to manage the existing users. The new users are created for the Employee Contacts if there exists a User with its ContactId 
*     as the new Contact's ID, then the User get modified. 
* 
*    History
*    --------
*
*    VERSION    AUTHOR         DATE        DETAIL 
*       1.0     IDC Offshore   26/07/2013  Replaced hvProfile Name hardcoding with Custom Setting
*       2.0     IDC Offshore   30/07/2013  Added Comments and Indentation
*       3.0     IDC Offshore   21/04/2014  Req2978 Release5 Bargaining Unit Changes
*       4.0     IDC Offshore   10/11/2014  For PCRM - Creation of new users for Provider Contacts and to managing the existing ones.
*       5.0     IDC Offshore   22/01/2015  PCRM Phase1 Code changes with new enhancements.
*       6.0     IDC Offshore   25/03/2015  PDV REQ 3399 Code changes.
*		7.0		IDC Offshore   21/03/2016  PDI REQ 3824	Code changes - Update the ADID field on user object for internal providers.
*		
**/
public without sharing class ManageCommunityUsers {
    
    /** @Description: Empty Constructor.**/
    public ManageCommunityUsers(){}
    
    /**
*   @Description: This method is used to take a list of employee contacts and create new user's list if the Contact Employee Status is Active
*   @Arguments: List of Contacts
*   @Return: Void
**/
    public static void CreateNewUsers(List<Contact> newContacts) {
        
        System.Debug('Users 1');
        
        /** @Description: List variables to store user information.**/
        List<String> str_contId = new List<String>();
        List<String> str_alias = new List<String>();
        List<String> str_email = new List<String>();
        List<String> str_firstName = new List<String>();
        List<String> str_lastName = new List<String>();
        List<String> str_nickName = new List<String>();
        List<String> str_name = new List<String>();
        List<String> str_union = new List<String>();
        /**@Description: Req2978 R5(Added String List for bargaining union field.**/ 
        List<String> str_bargaining = new List<String>();
        List<String> str_benefit = new List<String>();
        List<String> str_affiliate = new List<String>();
        //  List<String> str_ADID = new List<String>();//SSO-ADID
        List<String> str_title = new List<String>();
        String standardProfileID = getStandardProfileId();
        String managerProfileID = getManagerProfileID();
        String profileId = '';
        // Atul profileMap
        Map<String, String> contact_profileMap = new Map<String, String>();
        // Req #3191
        //Map<Id,boolean> contactIdToExeStatus = new Map<Id,boolean>();
        //Map<Id,String> contactIdToFacilty = new Map<Id,String>();
        
        /*************SSO Change***************/
        List<String> ADIDs = new List<String>();
        /***************************************/
        
        /*************Req 3676 Permission Set assignments based on EEO Sub code/Company code/Process Level***************/
        List<String> EEOSubcode = new List<String>();
        List<String> Companycode = new List<String>();
        List<String> Processlevel = new List<String>();     
        /***************************************/
        
        Map<String, Boolean> userStatus = new Map<String, Boolean>();
        Integer loopCount = 0;
        
        //Atul create profileMap
        for(Contact con: newContacts){
            
            if(con.Employee_EEO_SubCode__c == '0') profileId = standardProfileID; 
            else if(con.Employee_EEO_SubCode__c != '0') profileId = managerProfileID; 
            
            contact_profileMap.put(con.id, profileId);
            // Req #3191
            //contactIdToExeStatus.put(con.id,con.Employee_Executive_Status__c);
            //contactIdToFacilty.put(con.id,con.Employee_Affiliate_Facility__c);            
        }
        
        /** @Description: Iterate over the Contact list to check the status of individual contact record.**/
        for(Contact loopContact: newContacts){
            System.Debug('Users 2');
            // Atul 
            /** @Description: Method, To get the ID of the profile 'Communities_Portal'.**/
            //profileId = getProfileId(loopContact);
            
            /** @Description: Validating the Contact Employee Status.**/ 
            //Atul remove userProv
            if(isActiveUserStatus(loopContact.EMPLOYEE_EMPLOYMENT_STATUS__C, loopContact.EMPLOYEE_AFFILIATE_FACILITY__C)){
                System.debug('contact findMe' + loopContact.Id);
                if(loopContact.Employee_Work_Email__c <> null){
                    /** @Description: Populate the list variables.**/
                    str_contId.add(loopContact.Id);
                    str_alias.add(getPermissionString(getAlias(loopContact.FirstName, loopContact.LastName)));
                    str_email.add(getPermissionString(loopContact.Employee_Work_Email__c));
                    system.debug('fail email'+getPermissionString(loopContact.Employee_Work_Email__c));  
                    str_firstName.add(getPermissionString(loopContact.FirstName));
                    str_lastName.add(getPermissionString(loopContact.LastName));
                    str_nickName.add(getPermissionString(getnickName(loopContact.Employee_Work_Email__c)));
                    str_name.add(getPermissionString(loopContact.Employee_Work_Email__c));
                    str_union.add(getPermissionString(loopContact.EMPLOYEE_UNION_AFFILIATE__C));          
                    
                    /** @Description: Req2978 R5 Bargaining Unit Changes (Added permission string for Bargaining Union field).**/
                    str_bargaining.add(getPermissionString(loopContact.Employee_Bargaining_Union__c));
                    
                    system.debug('getPermissionString(loopContact.EMPLOYEE_UNION_AFFILIATE__C)' + getPermissionString(loopContact.EMPLOYEE_UNION_AFFILIATE__C));
                    str_benefit.add(getPermissionString(loopContact.EMPLOYEE_EMPLOYMENT_STATUS__C));
                    
                    system.debug('getPermissionString(loopContact.EMPLOYEE_EMPLOYMENT_STATUS__C)' + getPermissionString(loopContact.EMPLOYEE_EMPLOYMENT_STATUS__C));
                    str_affiliate.add(getPermissionString(loopContact.EMPLOYEE_AFFILIATE_FACILITY__C));
                    //          str_ADID.add(getPermissionString(loopContact.Employee_ADID__c));//SSO-ADID
                    system.debug('getPermissionString(loopContact.EMPLOYEE_AFFILIATE_FACILITY__C)' + getPermissionString(loopContact.EMPLOYEE_AFFILIATE_FACILITY__C));
                    /*****************SSO Change ***************/
                    ADIDs.add(getPermissionString(loopContact.Employee_ADID__c));
                    /*******************************************/
                    
                    /*************Req 3676 Permission Set assignments based on EEO Sub code/Company code/Process Level***************/
                    EEOSubcode.add(getPermissionString(loopContact.Employee_EEO_SubCode__c));
                    Companycode.add(getPermissionString(loopContact.Employee_Company__c));
                    Processlevel.add(getPermissionString(loopContact.Employee_Process_Level__c));
                    
                    /***************************************/            
                    
                    
                }
            }
        }
        
        system.debug('>>>str_union>>>'+ str_union);
        system.debug('>>>str_bargaining>>>'+ str_bargaining);
        system.debug('>>>str_benefit>>>'+ str_benefit);
        system.debug('>>>str_affiliate>>>'+ str_affiliate);
        system.debug('>>>str_contId>>>'+ str_contId);            
        
        /** @Description: Method call to a Future Method to insert new users.**/
        //Atul add null check
        //SSO-ADID
        if(!str_contId.isEmpty()){
            createUser(str_contId, str_alias, str_email, str_firstName, str_lastName, str_name, contact_profileMap, str_nickName, str_union ,str_bargaining , str_benefit, str_affiliate, ADIDs,EEOSubcode,Companycode,Processlevel);
        }
    }
    
    
   /**
    * @author       :   IDC Offshore
    * @date         :   14/11/2014 (DD/MM/YYYY)
    * @version      :   4.0
    * @description  :   Added for PCRM - Creates User for those Contacts which are of Provider RecordType and assign employee ADID value to 
    * 					Federation Identifier on User object. 
    * @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
    * @return       :   N/A
    */ 
    public static void CreateProviderUsers(list<Contact> newContacts) {
        list<String> conIdList = new list<String>();
        list<String> aliasList = new list<String>();
        list<String> emailList = new list<String>();
        list<String> firstNameList = new list<String>();
        list<String> lastNameList = new list<String>();
        list<String> nickNameList = new list<String>();
        list<String> tempList = new list<String>();
        Map<Id, String> conId_FedId_map = new Map<Id, String>(); //PDI-Wave1 - Holds Contact Id and Employee ADID Value
        
        String alias;
        
        for(Contact loopContact: newContacts){
            
            conIdList.add(loopContact.Id);
            emailList.add(loopContact.Email);
            conId_FedId_map.put(loopContact.Id, loopContact.Employee_ADID__c); //PDI-Wave1 - Assign Contact Id and Employee ADID Value to conId_FedId_map
            
            if(loopContact.FirstName != null && loopContact.FirstName != '' && loopContact.LastName != null && loopContact.LastName != '') {
                alias = getAlias(loopContact.FirstName, loopContact.LastName);
            } else {
                tempList = loopContact.Email.split('@');
                if(tempList[0].length() > 8)    alias = tempList[0].subString(0,7);
                else alias = tempList[0];
            }
            
            aliasList.add(alias);
            
            if(loopContact.FirstName != null && loopContact.FirstName != '')    firstNameList.add(loopContact.FirstName);
            else firstNameList.add('FNU');
            
            if(loopContact.LastName != null && loopContact.LastName != '')  lastNameList.add(loopContact.LastName);
            else    lastNameList.add('LNU');
        }
        
        ManageCommunityUsers.createProviderUser(conIdList, aliasList, emailList, firstNameList, lastNameList, conId_FedId_map);
    }
    
    
    /**
* @author       :   IDC Offshore
* @date         :   17/03/2015 (DD/MM/YYYY)
* @version      :   6.0
* @description  :   Added for PDV REQ 3399- Update User for those Contacts which are of Provider RecordType. 
* @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
* @return       :   N/A
*/ 
    
    public static void UpdateProviderUsers(list<Id> newContacts) {
        
        system.debug('Total Records - UpdateProviderUsers:'+newContacts.size() );
        List<id> lstUsersInactive=new List<id>();
        Map<Id,User> mapProviderUsers=new map<Id,User>();
        List<Contact> lstContactUpdates=new List<Contact>();
        List<Contact> lstContactUpdateInactive=new List<Contact>();
        Map<Id,List<Contact_Validation_Summary__c>>mapContactRelatedSummary=new Map<id,List<Contact_Validation_Summary__c>>();
        list<User> userList = new list<User>();
        List<Contact_Validation_Summary__c> lstAllSummaries=new List<Contact_Validation_Summary__c>();
        list<Contact> conList = new list<Contact>();
        set<String> dupUserNameSet = new set<String>();
        String tempUserName;
        List<String> p_emailList=new List<String>();
        
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        Integer i = 0;
        
        String qryStrUN = '';
        
        
        // Fetching the Updated Contacts of Provider Recordtype
        List<Contact> lstProviderContacts=new List<Contact>([select id,Email,Username__c,Source_of_E_mail__c,Provider_Service_Status__c,Employee_ADID__c,Provider_Practicing_Physician__c,Provider_Retired_Departed__c,Provider_Resigned_From_Sutter__c,(select id from Summarys__r where Contact_Id__c in:newContacts) from Contact where id in:newContacts]);
        if(lstProviderContacts!=null && lstProviderContacts.size()>0)
        {
            for(Contact objContact:lstProviderContacts)
            {
                p_emailList.add(objContact.email);  
                mapContactRelatedSummary.put(objContact.id,objContact.Summarys__r);// getting the Provider Information Summary Records Related to the Contact
            }
            
            for(User objUser:[select id,email,username,contactid,isActive from user where contactid in:lstProviderContacts])
                mapProviderUsers.put(objUser.contactid,objUser);// Fetcing the Users Related to the Contacts
        }
        
        qryStrUN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
        
        
        for(String tempEMail: p_emailList) {
            qryStrUN = qryStrUN + '(Username like \'%'+tempEMail+'%\') OR ';
            
        }
        
        qryStrUN=qryStrUN.substring(0,qryStrUN.lastIndexOf('OR')-1);
        
        
        userList = database.query(qryStrUN);
        for(User tempUser : userList)  dupUserNameSet.add(tempUser.userName);
        
        
        for(Contact loopContact: lstProviderContacts){
            
            if(mapProviderUsers.get(loopContact.id)!=null)
            {
                User objUser=  mapProviderUsers.get(loopContact.id);        
                /* * If the Contact is of Teleform or Non TeleForm type and is not Resigned or Retired * */
                if( loopContact.Provider_Service_Status__c==null || loopContact.Provider_Practicing_Physician__c == true){
                    tempUserName = mcuObj.getUniqueUnameOrCNickName(loopContact.Email,dupUserNameSet,'username');//Fetching the Unique Username
                    dupUserNameSet.add(tempUserName);
                    
                    loopContact.Username__c=tempUserName;// Copying the Unique Username in Contact's Username Field
                    lstContactUpdates.add(loopContact);
                }
                
                /* *Checking if The Contact's Provider Service Status is Retired or Resigned. * */
                
                else if(loopContact.Provider_Retired_Departed__c == true || loopContact.Provider_Resigned_From_Sutter__c == true)
                {
                    List<Contact_Validation_Summary__c> lstContactSummaries=mapContactRelatedSummary.get(loopContact.id);
                    
                    if(lstContactSummaries!=null && lstContactSummaries.size()>0)
                    {
                        
                        for(Contact_Validation_Summary__c objSummary:lstContactSummaries)   
                            lstAllSummaries.add(objSummary); // Adding the Related Provider Information Summary Records
                        
                    }
                    loopContact.Is_Portal_User__c = false;
                    loopContact.Email_Alert__c = 'NO';
                    loopContact.Username__c = null;
                    
                    lstContactUpdateInactive.add(loopContact);
                    lstUsersInactive.add(objUser.id); // Adding Users that are to be made Inactive
                }   
            }  
        }
        
        
        if(lstContactUpdateInactive!=null && lstContactUpdateInactive.size()>0)
            update lstContactUpdateInactive;
        
        if(lstContactUpdates!=null && lstContactUpdates.size()>0)
        {
            update lstContactUpdates;// Updating Contacts
            List<id> lstUpdatedContacts=new List<id>();
            
            for(Contact objCon:lstContactUpdates)
                lstUpdatedContacts.add(objCon.id);// Fetching the Id of the Updated contacts
            if(lstUpdatedContacts!=null && lstUpdatedContacts.size()>0)
                ManageCommunityUsers.UpdateProviderUsersTeleForm(lstUpdatedContacts);// Passing Id of Contacts whose User is also to be updated
            
        }
        /*@PDI-Wave1 Description: commented as part of PDI Wave1      
/*if(lstAllSummaries!=null && lstAllSummaries.size()>0){
delete lstAllSummaries; // Deleting Related Provider Information Summary Records
}*/
        
        if(lstUsersInactive!=null && lstUsersInactive.size()>0)
            ManageCommunityUsers.ProviderUserInactive(lstUsersInactive);// Passing the Id of Users that are to be made inactive
    }
    
    /**
* @author       :   IDC Offshore
* @date         :   18/03/2015 (DD/MM/YYYY)
* @version      :   6.0
* @description  :   Added for PDV REQ 3399- Make Users Inactive for those Contacts which are of Provider RecordType and have Retired or Resigned. 
* @param        :   List [Id] - Will always contain Id of Users who are to be made inactive
* @return       :   N/A
*/ 
    
    
    
    @future
    public static void ProviderUserInactive(list<Id> lstUsersUpdate) {
        
        
        /** Fetching Users from User object based on the Ids that have been passed **/
        List<user> lstUsersUpd=new List<user>([select id,isActive from user where id in:lstUsersUpdate]);   
        List<user> lstUsersToUpdate=new List<user>();
        
        if(lstUsersUpd!=null && lstUsersUpd.size()>0)
            
            for(User objUser:lstUsersUpd)
        {
            objUser.isActive=false;// Making the User Inactive
            lstUsersToUpdate.add(objUser);
            
        }
        
        if(lstUsersToUpdate!=null && lstUsersToUpdate.size()>0)
            update lstUsersToUpdate;// Updating Users
        
    }
    
    
    /**
* @author       :   IDC Offshore
* @date         :   18/03/2015 (DD/MM/YYYY)
* @version      :   6.0
* @description  :   Added for PDV REQ 3399- Update Users related to the Contacts with the updated Email id and appropriate Username. 
* @param        :   List [Id] - Will always contain Id of Contacts whose users are to be updated
* @return       :   N/A
*/ 
    
    
    @future
    public static void UpdateProviderUsersTeleForm(list<Id> lstUpdatedContacts) {
        system.debug('Total Records:'+lstUpdatedContacts.size()) ;   
        
        Map<Id,User> mapProviderUsers=new map<Id,User>();
        List<Contact> lstContacts;
        List<User> lstUsersToUpdate=new List<User>();
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        
        if(lstUpdatedContacts!=null && lstUpdatedContacts.size()>0)
        {
            
            /* Fetching Users related to the Updated Contacts.
* PDI- Wave1 : Add Employee_ADID__c and FederationIdentifier in below select queries.
*/
            lstContacts=new List<Contact>([select id,Username__c,email,Source_of_E_mail__c,Provider_Service_Status__c,Provider_Practicing_Physician__c,Provider_Resigned_From_Sutter__c,Provider_Retired_Departed__c,Employee_ADID__c from Contact where id in :lstUpdatedContacts]);
            
            for(User objUser:[select id,email,username,CommunityNickname,contactid,isActive,FederationIdentifier from user where contactid in:lstUpdatedContacts])
                mapProviderUsers.put(objUser.contactid,objUser);// Fetcing the Users Related to the Contacts
            
            
            for(Contact objContact:lstContacts)
            {
                if(mapProviderUsers.get(objContact.id)!=null 
                   && objContact.Provider_Practicing_Physician__c == true)  //checking if we are getting the Related user to the current Contact in the loop.
                {
                    User objUsr=mapProviderUsers.get(objContact.id);
                    
                    // Updating the Users's Username and Email 
                    objUsr.username=objContact.username__c;
                    objUsr.email=objContact.Email;
                    String federationIdentifier = null;
                    if(objContact.Employee_ADID__c != null){
                        federationIdentifier = objContact.Employee_ADID__c + Label.CL377_PDI_ADIDSuffix;
                    }
                    objUsr.FederationIdentifier = federationIdentifier; //PDI-Wave1 -Assigning the employee ADID to federation IDentifier
                    lstUsersToUpdate.add(objUsr);   
                }   
            }
            if(lstUsersToUpdate!=null && lstUsersToUpdate.size()>0)
               
            update lstUsersToUpdate;// Updating Users
        }
    }
    
    
    
    
    /**
* @author       :   IDC Offshore
* @date         :   14/11/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for PCRM - Future method for Creating users 
* @param        :   List [String], List [String], List [String], List [String], List [String]
* @return       :   N/A
*/ 
    @future 
    public static void createProviderUser(List<String> p_conIdList, List<String> p_aliasList, List<String> p_emailList, List<String> p_firstNameList, List<String> p_lastNameList, Map<Id, String> conId_FedId_map) {
        
        list<User> adidUserList = new list<User>(); //PDI-Wave1
        list<User> nonADIDUserList = new list<User>(); //PDI-Wave1
        list<User> userList = new list<User>();
        list<User> userSuccessList = new list<User>();
        list<User> userFailList = new list<User>();
        list<Contact> conList = new list<Contact>();
        
        set<Id> userSuccessConIdSet = new set<Id>();
        set<String> dupUserNameSet = new set<String>();
        set<String> dupCNickNameSet = new set<String>();
        
        
        map<id,string> contId_username_map = new map<id,string>();
        
        String tempNickName;
        string tempUserName;
        Database.SaveResult[] srList;
        Database.SaveResult[] srList1;
        
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        HandleFailedContacts hfcObj = new HandleFailedContacts();
        Integer i = 0;
        
        String qryStrUN = '';
        String qryStrCNN = '';
        String failRecordsErrHTMLStr = '';
        list<SystemException__c> sysExceptionList = new list<SystemException__c>();
        
        
        
        Id userProfileId = [select id, name from Profile where name = :CS_ManageProfile__c.getInstance('Communities_Provider').Profile_Name__c LIMIT 1].id;
        
        try {
            
            qryStrUN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
            qryStrCNN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
            
            for(String tempEMail: p_emailList) {
                qryStrUN = qryStrUN + '(Username like \'%'+tempEMail+'%\') OR ';
                qryStrCNN = qryStrCNN + '(CommunityNickname like \'%'+tempEMail+'%\' ) OR ';
            }
            
            qryStrUN=qryStrUN.substring(0,qryStrUN.lastIndexOf('OR')-1);
            qryStrCNN=qryStrCNN.substring(0,qryStrCNN.lastIndexOf('OR')-1);
            
            userList = database.query(qryStrCNN);
            for(User tempUser : userList)   dupCNickNameSet.add(tempUser.CommunityNickname);
            
            userList = database.query(qryStrUN);
            for(User tempUser : userList)  dupUserNameSet.add(tempUser.userName);
            
            /** @Description: Allowing of email whenever the user is inserted. **/
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = true;
            
            /** @Description: Creating New User's List**/
            userList = new list<User>();
            /** @Description New map with contact id and username **/
            map<id,string> contId_username_u_map = new map<id,string>();
            for(i = 0; i < p_conIdList.size(); i++) {
                
                tempNickName = p_emailList[i];//MP-Only Email part before @
                tempUserName = p_emailList[i];
                
                //tempNickName = tempNickName.subString(0,tempNickName.lastIndexOf('@'));
                tempNickName = mcuObj.getUniqueUnameOrCNickName(tempNickName,dupCNickNameSet,'nickname');
                
                //tempNickName = getnickName(tempNickName) + '.'+ tempNickName.subString(tempNickName.lastIndexOf('.')+1,tempNickName.length());
                dupCNickNameSet.add(tempNickName);
                
                tempUserName = mcuObj.getUniqueUnameOrCNickName(tempUserName,dupUserNameSet,'username');
                dupUserNameSet.add(tempUserName);
                String federationId = null;
                if(conId_FedId_map.get(p_conIdList[i]) != null){
                    federationId = conId_FedId_map.get(p_conIdList[i]) + Label.CL377_PDI_ADIDSuffix;
                }
                userList.add(new User(
                    alias = p_aliasList[i]
                    , email = p_emailList[i]
                    , CommunityNickname = tempNickName
                    , emailencodingkey = 'UTF-8'
                    , firstname = p_firstNameList[i]
                    , lastname = p_lastNameList[i]
                    , languagelocalekey = 'en_US'
                    , UserRoleId = null
                    , localesidkey = 'en_US'
                    , profileid = userProfileId
                    , contactId = p_conIdList[i]
                    , isActive = true
                    , timezonesidkey = 'America/Los_Angeles'
                    , username = tempUserName
                    , FederationIdentifier = federationId  //PDI-Wave1 : Getting ADID value based on contact Id from conId_FedId_map and assigning to FederationIdentifier field in User Object
                ));
                
                /** Post Production Enhancements ---Contact User Name Update **/
                contId_username_u_map.put(p_conIdList[i],tempUserName);
                
            }
            
            /** @Description: Inserting Users **/
            srList = Database.insert(userList, false);
                       
            i=0;
            
            for(Database.SaveResult sr : srList){
                if(sr.isSuccess())  userSuccessList.add(userList[i]);
                else    userFailList.add(userList[i]);
                
                i = i + 1;
            }
            /** @Description: Trying to insert the failed records again **/
            srList1 = Database.insert(userFailList, false);
            i=0;
            
            for(Database.SaveResult sr : srList1){
                if(sr.isSuccess()) {
                    userSuccessList.add(userList[i]);
                } else {
                    hfcObj.addToFailList(userList[i],sr);
                }
                
                i = i + 1;
            }
            
            hfcObj.insertFailList();
            
            /** @Description: Updating the Portal User Flag on Contact Record for successfully created Users**/
            if(!userSuccessList.isEmpty()) {
                for(User tempUser : userSuccessList)    userSuccessConIdSet.add(tempUser.contactId);
                
                hfcObj.removeFromFailList(userSuccessConIdSet);
                
                conList = [SELECT id, Email, Is_Portal_User__c FROM Contact WHERE id IN :userSuccessConIdSet];
                for(Contact temp: conList)  temp.Is_Portal_User__c = true;
                
                /** Post Production Enhancements ---Contact User Name Update **/
                
                for(Contact temp: conList)  {
                    if (contId_username_u_map.containsKey(temp.id)){
                        
                        temp.Username__c =  contId_username_u_map.get(temp.id);  //u.username;          
                    }
                    
                }
                /** Contact User Name Update **/
                update conList;
            }
            
        } catch (Exception classException) { 
            String errStr = classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------';
            sysExceptionList.add(new SystemException__c(ExceptionMessage__c = errStr));
            insert sysExceptionList;
        }
    }
    
    
    /**
* @author       :   IDC Offshore
* @date         :   18/11/2014 (DD/MM/YYYY)
* @version      :   4.0
* @description  :   Added for PCRM - Returns a unique string that can be used as a Username or Community Nick Name 
based upon the passed values. 
P.S. Passed values should be of E-Mail format. 
* @param        :   String p_str, Set [p_strSet]
* @return       :   String
*/ 
    public String getUniqueUnameOrCNickName(String p_str,set<String> p_strSet, String p_type) {
        list<String> tempArr;
        
        String retStr = p_str;
        String currCount;
        Integer nextCount;
        String temp;
        
        if(p_strSet.contains(retStr)) {
            currCount = retStr.subString(retStr.lastIndexOf('.')+1,retStr.length());
            
            try {
                nextCount = Integer.valueOf(currCount) + 1;
                retStr =  retStr.subString(0,retStr.lastIndexOf('.')+1) + String.valueOf(nextCount);
            } catch (Exception e) {
                retStr = retStr + '.1';
            }
            
            retStr = getUniqueUnameOrCNickName(retStr,p_strSet,p_type);          
        }
        
        if(p_type.equals('nickname') && retStr.length() >= 40) {
            currCount = retStr.subString(retStr.lastIndexOf('.')+1,retStr.length());
            temp = retStr.subString(0,retStr.lastIndexOf('@'));
            
            if(temp.length()>35) temp = temp.subString(0,35);
            retStr = temp + '.' + currCount;
        }
        
        return retStr;
    }
    
    
    /**
*   @Description: This method checks that for a contact updated, whether a user already exist or not.
*   If it exists, it updates the user according to the Contact or else it creates a new user
*   @Arguments: List of Contacts, Old <Id, Contact> Map for Contacts, New <Id, Contact> Map for Contcats 
*   @Return: Void
**/
    public static void ManageUsers(List<Contact> allContacts, Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        System.Debug('@@allcontacts' + allContacts);
        System.Debug('Users 4' + allContacts.size());
        
        /** @Description: Set variable to store Contact Ids**/
        Set<Id> updateContactIds = new Set<Id>();
        
        /** @Description: Map variable to store contact ID and User Information**/
        Map<Id, User> updateUserMap = new Map<Id, User>();
        
        /**
*   @Description: Method call to get a Map of Contact ID and User info. The parameter passed to this method is 
*   the Map returned by getContactUsers. The parameter passed to getContactUsers is the keyset of the Map returned
*   by getReducedMap.
**/
        updateUserMap = getContactIdUserMap(getContactUsers(getReducedMap(allContacts, oldMap).keySet()));
        system.debug('@@updateUserMap'+updateUserMap);
        
        /** @Description: Method call, To get ContactId associated with Users**/
        updateContactIds = getContactIdWithUsers(allContacts, updateUserMap);
        System.Debug('Users 5');
        system.debug('@@updateContactIds'+updateContactIds);
        
        /** @Description: validating list of contacts which do not have associated users is greater than zero.**/
        if(getNonUserContacts(updateContactIds, getContactMap(allContacts)).size() > 0) {
            
            /** @Description: method call to create new User**/
            CreateNewUsers(getNonUserContacts(updateContactIds, getContactMap(allContacts)));
        }
        System.Debug('beforepass'+ updateContactIds.size());
        system.debug('@@updateContactIds :'+updateContactIds);
        /** @Description: Validating list size of contacts with associated User is greater than zero.**/
        if(updateContactIds.size() > 0) {
            system.debug('Testing Executive Status');
            /** @Description: Method call, To manage existing Users.**/
            ManageCurrentUsers(updateContactIds, updateUserMap, oldMap, newMap); 
        }
    }
    
    /**
*   @Description: This method checks the old and new field values for Contact with existing users and accordingly will
*   group the users to be updated.
*   @Arguments: Set of Contact Ids, <Id, User> Map, Old <Id, User> Map for Contacts, New <Id, Contact> Map for Contcats 
*   @Return: Void
**/
    public static void ManageCurrentUsers(Set<Id> currentContacts, Map<Id, User> userMap, Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        
        /** @Description: List variables to store UserIds**/
        List<Id> unactivatedPSAUsers = new List<Id>();
        List<Id>  reactivatePSAUser = new List<Id>();
        List<Id> noChangePSAUser = new List<Id>();
        
        /** @Description: Map variables to store Id, String Information**/
        Map<Id, String> idAffiliateMap = new Map<Id, String>();
        //     Map<Id, String> idEmployeeADIDMap = new Map<Id, String>();//SSO-ADID
        Map<Id, String> idUnionPSMap = new Map<Id, String>();
        
        /** Req 3676 **/
        Map<Id, String> EEOsubcodeMap= new Map<Id, String>();  
        Map<Id, String> CompanycodeMap= new Map<Id, String>();
        Map<Id, String> ProcesslevelMap= new Map<Id, String>();
        
        /** @Description: Req2978 R5 Bargaining Unit Changes (String Map for storing Bargaining Permission Set Id)**/  
        Map<Id, String> idBargainingPSMap = new Map<Id, String>();
        Map<Id, String> idBenefitPSMap = new Map<Id, String>();
        Map<Id, String> idAffiliatePSMap = new Map<Id, String>();
        //Req# 3191
        //Map<Id, Boolean> contactIdToExeStatusMap = new Map<Id, Boolean>();
        //Map<Id, String> contactIdToFacilityMap = new Map<Id, String>();
        
        System.Debug('Users 6');
        
        /** @Description: Iterate over Contact Id set**/
        for(Id contactId: currentContacts) {
            
            /** @Description: If the value for Contact Status exist**/
            if(isValue(newMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C)) {
                
                /** @Description: Validate the Contact status is Active**/
                if(isActiveUserStatus(newMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, newMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C)) {
                    
                    /** @Description: Populate the Map variables with User Id as the Key**/
                    idUnionPSMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).EMPLOYEE_UNION_AFFILIATE__C));
                    
                    /** Req 3676 **/
                    EEOsubcodeMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).Employee_EEO_SubCode__c));
                    CompanycodeMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).Employee_Company__c));
                    ProcesslevelMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).Employee_Process_Level__c));
                    
                    /**@Description: Req2978 R5 Bargaining Unit Changes(Populating Map variable with user id of Bargaining union field.**/
                    idBargainingPSMap.put(userMap.get(contactId).Id,getPermissionString(newMap.get(contactId).EMPLOYEE_BARGAINING_UNION__C));
                    idBenefitPSMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C));
                    idAffiliatePSMap.put(userMap.get(contactId).Id, getPermissionString(newMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C));
                    //Req# 3191
                    //contactIdToExeStatusMap.put(contactId, newMap.get(contactId).Employee_Executive_Status__c);                  
                    //contactIdToFacilityMap.put(contactId, newMap.get(contactId).Employee_Affiliate_Facility__c); 
                    
                    system.debug('Status Old Value'+(!(isValue(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C))));
                    system.debug('Status Old Value'+(!(isActiveUserStatus(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C))));
                    
                    /** @Description: Checking the Old Contact Status was null or Inactive**/ 
                    if((!(isValue(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C))) || (!(isActiveUserStatus(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C)))) {              
                        
                        /** @Description: Populate the list with User Id**/
                        reactivatePSAUser.add(userMap.get(contactId).Id);
                        
                    } 
                    /** @Description: If the Old Contact Status Exist and was Active**/
                    else if((isValue(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C)) && (isActiveUserStatus(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C))) {
                        
                        /** @Description: Populate the list with User Id**/
                        noChangePSAUser.add(userMap.get(contactId).Id);
                    }
                } 
                /** @Description: If the Old Contact Status Exist and was Active**/
                else if((isValue(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C)) && (isActiveUserStatus(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C))) {
                    
                    /** @Description: Populate the list with User Id**/
                    unactivatedPSAUsers.add(userMap.get(contactId).Id);
                }
                
            } 
            /** @Description: If the Old Contact Status Exist and was Active**/
            else if((isValue(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C)) && (isActiveUserStatus(oldMap.get(contactId).EMPLOYEE_EMPLOYMENT_STATUS__C, oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C))) {
                
                /** @Description: Populate the list with User Id**/
                unactivatedPSAUsers.add(userMap.get(contactId).Id);
            }
            
            /** @Description: If the Contact Affiliate Facility exist**/
            if(isValue(newMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C)) {
                
                /** @Description: If the Affiliate Facility for a Contact is Changed**/
                if((oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C) != (newMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C)) {
                    
                    /** @Description: Populate the map with user Id and new Value of Contcat Affiliate Facility**/
                    idAffiliateMap.put(usermap.get(contactId).Id, newMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C);
                }
            } else {
                
                /** @Description: If the old Contact Affiliate Facility exist**/
                if(isValue(oldMap.get(contactId).EMPLOYEE_AFFILIATE_FACILITY__C)) {
                    
                    /** @Description: Populate the map with user Id and blank value**/
                    idAffiliateMap.put(usermap.get(contactId).Id, '');
                }
            } 
            
            
            
        }
        
        /** @Description: Method call to a Future Method to update the Users and SSO-ADID   idEmployeeADIDMap**/
        setUserChanges(unactivatedPSAUsers, reactivatePSAUser, noChangePSAUser, idUnionPSMap, idBargainingPSMap, idBenefitPSMap, idAffiliatePSMap, idAffiliateMap,EEOsubcodeMap,CompanycodeMap,ProcesslevelMap);
    }
    
    /**
*   @Description: This method returns True if Contact Status is active.
*   @Arguments: String 
*   @Return: Boolean
**/
    public static Boolean isActiveUserStatus(String contactStatus, String contactFacility) {
        
        Boolean returnValue = false;
        System.Debug('Users 21');
        Map<String, ActiveStatus__c> activeFields = ActiveStatus__c.getAll();
        Map<String, Salesforce_Affiliates__c> salesforceAffiliates = Salesforce_Affiliates__c.getAll();
        
        /** @Description: If Contact status exist**/
        if(isValue(contactStatus) && isValue(contactFacility)) {
            System.Debug('Users 21a');
            /** @Description: If Contact Status **/
            //Atul debug
            
            if(salesforceAffiliates.containsKey(contactFacility)){
                system.debug('@@salesforceAffiliate :'+ salesforceAffiliates.get(contactFacility).isSalesforce_True__c);
                system.debug('@@contactStatus :'+ activeFields.containsKey(contactStatus));
                if(activeFields.containsKey(contactStatus) && salesforceAffiliates.get(contactFacility).isSalesforce_True__c) {
                    System.Debug('Users 21b');
                    
                    returnValue = true;
                }
            }   
        }
        System.Debug('Users 21c' + returnValue);
        /** @Description: Return the Boolean**/
        return returnValue;
    }
    
    /**
*    @Description: This method returns a set of Ids of Contacts for which a user already exists
*    @Arguments: List of Contacts, Map of Contact Id and User
*    @Return: Set of Contact Id
**/
    public static Set<Id> getContactIdWithUsers(List<Contact> contactList, Map<Id, User> userMap) {
        Set<Id> returnContactSet = new Set<Id>();
        /** @Description: Iterate over Contact List**/
        for(Contact loopContact: contactList) {
            /** @Description: If the Contact Id is present as User's ContactId**/
            if(usermap.containsKey(loopContact.Id)) {
                /** @Description: Add the Contact Id to Set**/
                returnContactSet.add(loopContact.Id);
            }
        }
        /** @Description: Return The set**/
        return returnContactSet;
    }
    
    /**
*    @Description: This method returns a map of ContactIds and Users 
*    @Arguments: List of Users
*    @Return: Map of ContactId and User
**/
    public static Map<Id, User> getContactIdUserMap(List<User> users) {
        Map<Id, User> returnMap = new Map<Id, User>();
        /** @Description: Iterate over List of Users**/
        for(User loopUser: users) {
            /** @Description: Populate the map with ContactId and User**/
            returnMap.put(loopUser.ContactId, loopUser);
        }
        /** @Descrption: Return the Map**/
        return returnMap;
    }
    /**
*    @Description: This method returns Map of Id and Contact
*    @Arguments: List of Contacts
*    @Return: Map of Id and Contact
**/
    public static Map<Id, Contact> getContactMap(List<Contact> contacts) {
        Map<Id, Contact> returnMap = new Map<Id, Contact>();
        /** @Description: Iterate over Contact List**/
        for(Contact loopContact: contacts) {
            /** @Description: Populate the Map with Id and Contact**/
            returnMap.put(loopContact.Id, loopContact);
        }
        /** @Description: Return Map**/
        return returnMap;
    }
    /**
*   @Description: This method returns Map of Id and Contact
*   @Arguments: List of Contacts, Map of Id and Contact
*   @Return: Map of Id and Contact
**/
    public static Map<Id, Contact> getReducedMap(List<Contact> inputContactList, Map<Id, Contact> inputContactMap) {
        Map<Id, Contact> returnMap = new Map<Id, Contact>();
        /** @Description: If list of Contact is not empty**/
        if(!(inputContactList.isEmpty())) {
            /** @Description: For all the Contacts in Contact List**/
            for(Integer i = 0; i < inputContactList.size(); i++) {
                /** @Description: Populate the map**/
                returnMap.put(inputContactList[i].Id, inputContactMap.get(inputContactList[i].Id));
            }
        }
        /** @Description: Return the map of Id and contact**/
        return returnMap;
    }
    /**
*    @Description: This method returns List of Contacts for which a user does not exist
*    @Arguments: Map of Id and Contact, Set of User ContactId
*    @Return: List of Contacts
**/
    public static List<Contact> getNonUserContacts(Set<Id> userContactSet, Map<Id, Contact> allContactMap) {
        
        List<Contact> returnContactList = new List<Contact>();
        
        /** @Description: Iterate over Contact Map keyset**/
        for(Id contactId: allContactMap.keySet()) {
            /** @Description: If Contact Id is not Contained in the User ContactId set**/  
            if(!(userContactSet.Contains(contactId))) {
                /** @Description: Add to the list**/
                returnContactList.add(allContactMap.get(contactId));  
            }
        }
        /** @Description: Return the list**/
        return returnContactList; 
    }
    /**
*   @Description: This method returns list of existing users for the Contact which are updated 
*   @Arguments: List of Users
*   @Return: Set of Id of Contacts
*   @Exception: This method call is to a future method that accepts the string build out of details about 
*    the exception and stores that exception in a custom object that can be reported on. This call does
*    not follow standards for line length to increase test code coverage.
*    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
**/
    public static List<User> getContactUsers(Set<Id> contactSet) {
        List<User> currentUsers = new List<User>();
        /** @Description: Query all Users whose ContactId exists in passed parameter contactSet**/
        currentUsers = [select Id, isActive, ContactId,Email,Username From User Where ContactId IN :contactSet];
        /** @Description: return List**/
        return currentUsers;
    }
    /**
*    @Description: This method returns the nickname by processing the email 
*    @Arguments: String
*    @Return: String
**/
    public static String getNickName(String email) {
        /** @Description: Return substring of email occuring before '@'**/
        return email.substringBefore('@');
    }
    
    /**
*    @Description: This method returns the alias of User by processing first name and last name 
*    @Arguments: String, String
*    @Return: String
**/   
    public static String getAlias(String firstName, String lastName) {
        /** @Description: returns the 1 letter from the left of first name and 5 letters from the left of last name**/
        return (!string.IsBlank(firstName)?firstName.left(1):' ') + lastName.left(5);
    }
    /**
*    @Description: This method returns the profile Id for the profile 'Communities_Portal' 
*    @Return: String
*    @Exception: This method call is to a future method that accepts the string build out of details about 
*    the exception and stores that exception in a custom object that can be reported on. This call does
*    not follow standards for line length to increase test code coverage.
*    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
**/
    /** returns the profile ID for a standard employee user - EEO Subcode == 0 **/
    public static String getStandardProfileID() {
        String standardProfileID; 
        try{ 
            Profile highVolumeProfile = [select hvProfile.Id, hvProfile.Name from Profile hvProfile where Name =: CS_ManageProfile__c.getInstance('Communities_Portal').Profile_Name__c LIMIT 1];
            standardProfileId = highVolumeProfile.Id;   
        } catch(Exception classException) {
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        // return the standard Profile ID 
        return standardProfileID;     
    } 
    /*returns the profile ID for a standard employee user - EEO Subcode == 0 */
    public static String getManagerProfileID() {
        String managerProfileID; 
        try {  
            Profile highVolumeManagerProfile = [select managerProfile.Id, managerProfile.Name from Profile managerProfile where Name =: CS_ManageProfile__c.getInstance('Community_Portal_Manager').Profile_Name__c LIMIT 1];
            managerProfileId = highVolumeManagerProfile.Id;   
        } catch(Exception classException) {
            
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
            Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        
        // return the standard Profile ID 
        return managerProfileID;     
    }
    
    //Async method, using @future, to create the User record and associate it to the previously created Contact
    //This uses @future because you can not have mixed DML operations for standard objects (Account, Contact) and Setup objects(User)
    
    
    /**
*   @Description: As User is a setup object in salesforce, hence using future annotation method to insert Users
*   @Arguments: List of String, List of String, List of String, List of String, List of String, List of String, 
*   List of String, List of String, List of String, List of String, string  
*   @Return: Void
*   @Exception: An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
*   Included EmployeeADID Parameter for SSO List<String> EmployeeADID
**/
    @future 
    public static void createUser(List<String> contactId, List<String> alias, List<String> email, List<String> firstName, List<String> lastName, List<String> userName, Map<String,String> profileMap, 
                                  List<String> nickName, List<String> permissionUnion, List<String>permissionBargaining , List<String> permissionBenefit, List<String> permissionAffiliate,List<String> ADIDs,List<String> PermissionEEOSubcode,List<String> PermissionCompanycode,List<String> PermissionProcesslevel) {
                                      /** @Description: Set of all, successful and failed User Ids**/
                                      Set<String> allUserNames = new Set<String>();
                                      Set<Id> successfulUserIds = new Set<Id>();
                                      Set<String> successfulUserNames = new Set<String>();
                                      List<User> failedUserNames = new List<User>();
                                      /** @Description: List of Successfully inserted users **/
                                      List<User> successUserList = new List<User>();
                                      String emailString = '';
                                      /** @Description: List variable to store User Information**/                          
                                      List<User> insertList = new List<User>();
                                      
                                      /** @Description: Map variables to store Information**/
                                      Map<String, String> union= new Map<String, String>();
                                      
                                      /** @Description: Req2978 R5 Bargaining Unit Changes(Bargaining Union Map variables to store Information).**/
                                      Map<String, String> bargaining= new Map<String, String> ();  
                                      Map<String, String> benefit= new Map<String, String>();
                                      Map<String, String> affiliate= new Map<String, String>();
                                      Map<Id, String> passUnion= new Map<Id, String>();
                                      
                                      /** @Description: Req2978 R5 Bargaining Unit Changes(Bargaining Union Map variables to store Information).**/
                                      Map<Id, String> passBargaining= new Map<Id, String>();  
                                      Map<Id, String> passBenefit= new Map<Id, String>();
                                      Map<Id, String> passAffiliate= new Map<Id, String>();
                                      
                                      /**   Req 3676 **/
                                      Map<String, String> EEOsubcode= new Map<String, String>();
                                      Map<String, String> Companycode= new Map<String, String>();
                                      Map<String, String> Processlevel= new Map<String, String>();
                                      
                                      Map<Id, String> EEOsubcodeMap= new Map<Id, String>();  
                                      Map<Id, String> CompanycodeMap= new Map<Id, String>();
                                      Map<Id, String> ProcesslevelMap= new Map<Id, String>();
                                      
                                      set<string> userNameMap = new set<string>();
                                      set<string> nickNameMap = new set<string>();
                                      
                                      List<User> existingUsernames = new List<User>();
                                      if(!userName.isEmpty())
                                      {
                                          String query= 'Select Id, UserName, CommunityNickname from User Where ';
                                          
                                          for(String varNickName: nickName)
                                          {
                                              query = query + '(CommunityNickname like \'%'+varNickName+'%\' ) OR ';
                                          }
                                          
                                          Integer lastIndex = query.lastIndexOf('OR');
                                          query=query.substring(0,lastindex-1);
                                          
                                          for(String varUsername: userName)
                                          {
                                              query = query + ' OR (Username like \'%'+varUsername+'%\')';
                                          }
                                          
                                          existingUsernames = database.query(query);
                                      }
                                      
                                      for(User tempUser : existingUsernames) 
                                      {
                                          userNameMap.add(tempUser.UserName);
                                          nickNameMap.add(tempUser.CommunityNickname);
                                      }
                                      
                                      /**@Description :Generating a random number through timestamp**/
                                      Integer counter = system.now().hour() + system.now().minute() + system.now().millisecond() + system.now().second();
                                      
                                      /** @Description: Allow sending of email whenever the user is inserted. **/
                                      Database.DMLOptions dmo = new Database.DMLOptions();
                                      dmo.EmailHeader.triggerUserEmail = true;
                                      
                                      /** @Description: For all Contacts in Contact Id List**/
                                      for(Integer i = 0; i < contactId.size(); i++) {
                                          string tempNickName = nickName[i];
                                          string tempUserName = username[i];
                                          if(nickNameMap.contains(nickName[i]))
                                          {
                                              tempNickName = nickName[i]+Label.NicknamePortal;
                                              if(nickNameMap.contains(tempNickName))
                                              {
                                                  tempNickName = nickName[i]+Label.NicknamePortal+counter++;
                                              }
                                          }
                                          nickNameMap.add(tempNickName);
                                          
                                          if(userNameMap.contains(username[i]))
                                          {
                                              tempUserName = username[i]+Label.NicknamePortal;
                                              if(userNameMap.contains(tempUserName))
                                              {
                                                  tempUserName = username[i]+Label.NicknamePortal+counter++;
                                              }
                                          }
                                          userNameMap.add(tempUserName);
                                          
                                          /** @Description: Create a new Instance of a User**/ 
                                          // Atul use profileMap 
                                          // SSO - ADID   FederationIdentifier = EmployeeADID[i]         
                                          User newUser = new User(alias = alias[i], email = email[i], CommunityNickname = tempNickName, employeeAffiliate__c = permissionAffiliate[i],
                                                                  emailencodingkey = 'UTF-8', firstname = firstName[i], lastname = lastName[i], languagelocalekey = 'en_US', UserRoleId = null,
                                                                  localesidkey = 'en_US', profileid = profileMap.get(contactId[i]), contactId = contactId[i], isActive = true,
                                                                  timezonesidkey = 'America/Los_Angeles', username = tempUserName,FederationIdentifier=ADIDs[i]);
                                          system.debug('what is my user name:' + username[i]);
                                          
                                          /** @Description: Populate the Maps**/
                                          union.put(tempNickName, permissionUnion[i]);
                                          
                                          /** Req 3676 **/
                                          EEOSubcode.put(tempNickName,PermissionEEOSubcode[i]);
                                          Companycode.put(tempNickName,PermissionCompanycode[i]);
                                          Processlevel.put(tempNickName,PermissionProcesslevel[i]);
                                          
                                          
                                          /** @Description: Req2978 R5 Bargaining Unit Changes(Populating Bargaining Union Map).**/
                                          bargaining.put(tempNickName, permissionBargaining[i]);
                                          benefit.put(tempNickName, permissionBenefit[i]);
                                          affiliate.put(tempNickName, permissionAffiliate[i]);
                                          newUser.setOptions(dmo);
                                          /** @Description: add the new User to list**/
                                          insertList.add(newUser);
                                      }
                                      
                                      for(User user : insertList){
                                          allUserNames.add(user.username);
                                      }
                                      
                                      
                                      try{
                                          
                                          set<String> successfulUserId = new set<string>();
                                          List<User> successUserListReinsert = new List<User>();
                                          set<string> successfulUserName = new set<string>();
                                          set<string> failedUserName = new set<string>();
                                          
                                          /** @Description: Inserting Users and saving the the inserted list in SaveResult **/
                                          Database.SaveResult[] srList = Database.insert(insertList, false);
                                          /** @Description: Iterate over user list**/
                                          for(User loopUser: insertList) {
                                              /** @Description: Populate the maps**/
                                              passUnion.put(loopUser.Id, union.get(loopUser.CommunityNickname));
                                              
                                              /** @Description: Req2978 R5 Bargaining Unit Changes(Populating Bargaining Union Map).**/
                                              passBargaining.put(loopUser.Id, bargaining.get(loopuser.CommunityNickname));
                                              passBenefit.put(loopUser.Id, benefit.get(loopUser.CommunityNickname));
                                              passAffiliate.put(loopUser.Id, affiliate.get(loopUser.CommunityNickname));
                                              /** Req 3676 **/
                                              EEOsubcodeMap.put(loopUser.Id, EEOSubcode.get(loopUser.CommunityNickname));
                                              CompanycodeMap.put(loopUser.Id, Companycode.get(loopUser.CommunityNickname));
                                              ProcesslevelMap.put(loopUser.Id, Processlevel.get(loopUser.CommunityNickname));
                                          }
                                          
                                          /** @Description: Add successfully inserted Ids to the set **/
                                          for(Database.SaveResult sr : srList){
                                              if(sr.isSuccess()){
                                                  successfulUserIds.add(sr.getId());
                                              }
                                              else {
                                                  // Operation failed, so get all errors                
                                                  for(Database.Error err : sr.getErrors()) {
                                                      System.debug('Insert User :: The following error has occurred.');                    
                                                      System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                                      System.debug('Insert User :: User fields that affected this error: ' + err.getFields());
                                                  }
                                              }
                                          }
                                          
                                          successUserList = [Select Id, username from User where Id IN : successfulUserIds];
                                          
                                          for(User user : successUserList){
                                              successfulUserNames.add(user.username);
                                          }
                                          /** @Description: Add failed User Ids to the set **/
                                          for(User user : insertList){
                                              if(!successfulUserNames.contains(user.Username)){
                                                  failedUserNames.add(user);
                                              }
                                          }
                                          
                                          Database.SaveResult[] srListReinsert = Database.insert(failedUserNames, false);
                                          
                                          for(Database.SaveResult sr : srListReinsert){
                                              if(sr.isSuccess()){
                                                  successfulUserId.add(sr.getId());
                                              }
                                              else {
                                                  // Operation failed, so get all errors                
                                                  for(Database.Error err : sr.getErrors()) {
                                                      System.debug('Insert User :: The following error has occurred.');                    
                                                      System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                                      System.debug('Insert User :: User fields that affected this error: ' + err.getFields());
                                                  }
                                              }
                                          }
                                          
                                          successUserListReinsert = [Select Id, username from User where Id IN : successfulUserId];
                                          
                                          for(User user : successUserListReinsert){
                                              successfulUserName.add(user.username);
                                          }
                                          
                                          for(string str : allUserNames){
                                              if(!successfulUserName.contains(str) && !successfulUserNames.contains(str)){
                                                  failedUserName.add(str);
                                              }
                                          }
                                          
                                          /** @Description: Send out an email if any of the User records have failed **/
                                          if(!failedUserName.isEmpty()){
                                              for(String str : failedUserName){
                                                  emailString = emailString + str + '\r\n';
                                              }
                                              Utility.sendErrorEmail('###User Names failed to insert ::  '+ emailString);
                                          }
                                          
                                          /** @Description: Method call to a method in helper class 'ManageUserPermissions' to set the permission set for the new Users**/
                                          ManageUserPermissions.setNewUserPermissions(insertList, passUnion, passBargaining, passBenefit, passAffiliate,EEOsubcodeMap,CompanycodeMap,ProcesslevelMap);//,mapContactIdToExeStatus,mapContactIdToFacilty
                                          
                                      } catch (Exception classException) {
                                          Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                                      }
                                  }
    
    /**
*   @Description: This is a future method to update Users
*   @Arguments: List of Id, List of Id, List of Id, Map of Id and String, Map of Id and String, Map of Id and String, Map of Id and String,     
*   @Return: Void
*   @Exception: This method call is to accepts the exception string build out of details about 
*    the exception and stores that exception in a custom object that can be reported on. This call does
*    not follow standards for line length to increase test code coverage.
*    An email containing the exception message and stack trace history is sent to the defined user in Custom Setting.
*    SSO-ADID:Employee ADID Parameter added Map<Id, String> idEmployeeADIDMap
**/
    @future
    public static void setUserChanges(List<Id> deactiveUserIds, List<Id> reactiveUserIds, List<Id> noChangeUserIds,
                                      Map<Id, String> idUnionPSMap,Map<Id, String> idBargainingPSMap, Map<Id, String> idBenefitPSMap, Map<Id, String> idAffiliatePSMap, Map<Id, String> idAffiliateMap,Map<Id, String> EEOsubcodeMap,Map<Id, String> CompanycodeMap,Map<Id, String> ProcesslevelMap) {
                                          
                                          /** @Description: Set of all, successful and failed User Ids**/
                                          Set<Id> allUserIdstoUpdate = new Set<Id>();
                                          Set<Id> successfulUserIds = new Set<Id>();
                                          Set<Id> failedUserIds = new Set<Id>();
                                          String emailString = '';
                                          
                                          Set<Id> soqlUserIds = new Set<Id>();
                                          Set<Id> allUserIds = new Set<Id>();
                                          Set<Id> allcontactIds = new Set<Id>();
                                          
                                          String standardProfileID = getStandardProfileId();
                                          String managerProfileID = getManagerProfileID(); 
                                          String newprofileId = '';
                                          Map<String, Contact> userIdContactMap = new Map<String, Contact>();
                                          Map<Id, Contact> contactIdMap = new Map<Id, Contact>();
                                          
                                          set<string> userNameMap = new set<string>();
                                          set<string> nickNameMap = new set<string>();
                                          
                                          /**@Description :Generating a random number through timestamp**/
                                          Integer counter = system.now().hour() + system.now().minute() + system.now().millisecond() + system.now().second();
                                          
                                          allUserIds.addAll(reactiveUserIds);
                                          allUserIds.addAll(noChangeUserIds);
                                          
                                          List<User> listUpdateUsers = [Select Id, ContactId from User where Id IN : allUserIds];
                                          for(User userone : listUpdateUsers){
                                              allcontactIds.add(userone.ContactId);
                                          }
                                          List<Contact> listUpdateContacts = [Select Employee_EEO_SubCode__c,Employee_ADID__c from Contact where Id IN : allcontactIds];
                                          
                                          for(Contact con : listUpdateContacts){
                                              contactIdMap.put(con.id, con);
                                              //profileId = getProfileId(con);
                                          }
                                          
                                          for(User userone : listUpdateUsers){
                                              userIdContactMap.put(userone.id, contactIdMap.get(userone.ContactId));
                                          }
                                          
                                          /** @Description: add to the set the User Ids**/
                                          soqlUserIds.addAll(deactiveUserIds);
                                          soqlUserIds.addAll(reactiveUserIds);
                                          soqlUserIds.addAll(noChangeUserIds);
                                          soqlUserIds.addAll(idAffiliateMap.keySet());
                                          //   soqlUserIds.addAll(idEmployeeADIDMap.keySet());//SSO-ADID
                                          Map<Id, User> updateUsers;
                                          
                                          /** @Description: Query Users whose ID exist in set and add to a Map  SSO-ADID FederationIdentifier **/
                                          updateUsers = new Map<Id, User> ([select Id, IsActive, EmployeeAffiliate__c, UserName, CommunityNickname from User where Id IN :soqlUserIds]);
                                          
                                          /** @Description: Iterate over the list**/
                                          for(Id loopId: deactiveUserIds) {
                                              
                                              /** @Description: Deactivate the Users**/
                                              updateUsers.get(loopId).IsActive = false;
                                              /*if(!userNameMap.contains(updateUsers.get(loopId).Username+system.label.DeactivatedPortalName))
{
updateUsers.get(loopId).Username = updateUsers.get(loopId).Username+system.label.DeactivatedPortalName;
}
else
{*/
                                              updateUsers.get(loopId).Username = updateUsers.get(loopId).Username+system.label.DeactivatedPortalName+Counter++;
                                              /****SSO Change****/
                                              updateUsers.get(loopId).FederationIdentifier = '';
                                              /**************/
                                              //}
                                              
                                              /*if(!nickNameMap.contains(updateUsers.get(loopId).CommunityNickname+system.label.DeactivatedPortalName))
{
updateUsers.get(loopId).CommunityNickname = updateUsers.get(loopId).CommunityNickname+system.label.DeactivatedPortalName;
}
else
{*/
                                              updateUsers.get(loopId).CommunityNickname = updateUsers.get(loopId).CommunityNickname+system.label.DeactivatedPortalName+Counter++;
                                              //}
                                          }
                                          
                                          /** @Description: Iterate over the list**/
                                          for(Id loopId: reactiveUserIds) {
                                              
                                              /** @Description: activate the Users**/
                                              updateUsers.get(loopId).IsActive = true;
                                              /****************SSO CHange***************/
                                              updateUsers.get(loopId).FederationIdentifier = userIdContactMap.get(loopId).Employee_ADID__c;
                                              /*******************************/
                                              
                                              if(updateUsers.get(loopId).Username.contains(system.label.DeactivatedPortalName))
                                              {
                                                  updateUsers.get(loopId).Username = updateUsers.get(loopId).Username.substringBefore(system.label.DeactivatedPortalName);
                                              }
                                              if(updateUsers.get(loopId).CommunityNickname.contains(system.label.DeactivatedPortalName))
                                              {
                                                  updateUsers.get(loopId).CommunityNickname = updateUsers.get(loopId).CommunityNickname.substringBefore(system.label.DeactivatedPortalName);
                                              }
                                              //newprofileId = getProfileId(userIdContactMap.get(loopId));
                                              if(userIdContactMap.get(loopId).Employee_EEO_SubCode__c == '0') newprofileId = standardProfileID; 
                                              else if(userIdContactMap.get(loopId).Employee_EEO_SubCode__c != '0') newprofileId = managerProfileID;
                                              updateUsers.get(loopId).profileId = newprofileId;
                                          }
                                          
                                          for(Id loopId: noChangeUserIds) {
                                              /****************SSO CHange***************/
                                              updateUsers.get(loopId).FederationIdentifier = userIdContactMap.get(loopId).Employee_ADID__c;
                                              /*******************************/
                                              //newprofileId = getProfileId(userIdContactMap.get(loopId));
                                              if(userIdContactMap.get(loopId).Employee_EEO_SubCode__c == '0') newprofileId = standardProfileID; 
                                              else if(userIdContactMap.get(loopId).Employee_EEO_SubCode__c != '0') newprofileId = managerProfileID;
                                              updateUsers.get(loopId).profileId = newprofileId;
                                          }
                                          
                                          /** @Description: Iterate over the map keyset**/
                                          for(Id loopId: idAffiliateMap.keySet()) {
                                              
                                              /** @Description: Change the Employee Affiliate for the Users**/
                                              updateUsers.get(loopId).EmployeeAffiliate__c = idAffiliateMap.get(loopId);
                                          }
                                          
                                          /** @Description: Iterate over the map keyset SSO-ADID**/
                                          
                                          
                                          
                                          try {
                                              system.debug('@@updateUsers :'+updateUsers);
                                              /** @Description: add all the User Ids to be updated **/
                                              for(User user : updateUsers.values()){
                                                  allUserIdstoUpdate.add(user.id);
                                              }
                                              
                                              set<string> successfulUserId = new set<string>();
                                              set<string> failedUserId = new set<string>();
                                              list<User> failedUserList = new list<User>();
                                              
                                              /** @Description: Update the Users and fetch the SaveResult object **/
                                              Database.SaveResult[] srUpdateList = Database.Update(updateUsers.values(), false);
                                              
                                              /** @Description: Add successful User Ids to the set by iterating over SaveResult List **/
                                              for(Database.SaveResult sr : srUpdateList){
                                                  if(sr.isSuccess()){
                                                      successfulUserIds.add(sr.getId());
                                                  }
                                                  else {
                                                      // Operation failed, so get all errors                
                                                      for(Database.Error err : sr.getErrors()) {
                                                          System.debug('Update User :: The following error has occurred :');                    
                                                          System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                                          System.debug('Update :: User fields that affected this error: ' + err.getFields());
                                                      }
                                                  }
                                              }
                                              
                                              /** @Description: Add failed User Ids to the set **/
                                              for(Id id : allUserIdstoUpdate){
                                                  if(!successfulUserIds.contains(id)){
                                                      failedUserIds.add(id);
                                                  }
                                              }
                                              
                                              for(Id id:failedUserIds){
                                                  failedUserList.add(updateUsers.get(id));
                                              }
                                              
                                              /** @Description: Update the Users and fetch the SaveResult object **/
                                              Database.SaveResult[] srUpdateListSecond = Database.Update(failedUserList, false);
                                              /** @Description: Add successful User Ids to the set by iterating over SaveResult List **/
                                              for(Database.SaveResult sr : srUpdateListSecond){
                                                  if(sr.isSuccess()){
                                                      successfulUserId.add(sr.getId());
                                                  }
                                                  else {
                                                      // Operation failed, so get all errors                
                                                      for(Database.Error err : sr.getErrors()) {
                                                          System.debug('Update User :: The following error has occurred :');                    
                                                          System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                                          System.debug('Update :: User fields that affected this error: ' + err.getFields());
                                                      }
                                                  }
                                              }
                                              
                                              for(Id id : allUserIdstoUpdate){
                                                  if(!successfulUserIds.contains(id) && !successfulUserId.contains(id)){
                                                      failedUserId.add(id);
                                                  }
                                              }
                                              
                                              /** @Description: Send out an email if any of the User records have failed to update **/
                                              if(!failedUserId.isEmpty()){
                                                  for(User u : [select Id, Username from User where Id IN : failedUserId]){
                                                      emailString = emailString + u.id + '\r' + 'Username: ' + u.Username + '\r\n';
                                                  }
                                                  Utility.sendErrorEmail('###User Names failed to Update ::  '+ emailString);
                                              }
                                          } catch(Exception classException) {   
                                              //SystemException__c systemException = new SystemException__c();
                                              //systemException.ExceptionMessage__c = classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------';
                                              //insert systemException;
                                              
                                              Utility.sendErrorEmail(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
                                          }
                                          
                                          /** @Description: Method call to a method in helper class 'ManageUserPermissions' to set the permission set for the the existing Users**/
                                          ManageUserPermissions.setCurrentUserPermissions(noChangeUserIds, deactiveUserIds, reactiveUserIds, idUnionPSMap, idBargainingPSMap,  idBenefitPSMap, idAffiliatePSMap,EEOsubcodeMap,CompanycodeMap,ProcesslevelMap);//3191 ,contactIdToExeStatusMap,contactIdToFaciltyMap
                                          
                                          
                                          
                                      }
    
    /**
*   @Description: This method returns a System Administrator User
*   @Return: User
**/
    public static User getExceptionUser() { 
        
        /** @Description: Query and Return an active user with System Administrator Profile**/
        return [select id, profile.name, IsActive from user where profile.name = 'system administrator' AND IsActive = true limit 1];   
    }
    
    /**
*   @Description: This method returns the input value if it exist else returns 'Blank'
*   @Arguments: string
*   @Return: string
**/
    public static String getPermissionString(String inputString) {
        String returnValue;
        
        /** @Description: if the Input string is not blank**/
        if(isValue(inputString)) {
            returnValue = inputString;
        } else{ 
            returnValue = 'blank';
        }
        
        /** @Description: Return Value**/
        return returnValue;
    }
    
    /**
*    @Description: This method returns true if the input string is not blank else returns false
*    @Arguments: string
*    @Return: Boolean
**/     
    public static Boolean isValue(String checkString) {
        
        Boolean returnValue = false;
        
        /** @Description: If input string is not null or not blank**/
        if(checkString != null && checkString != '') {
            returnValue = true;
        }
        
        /** @Description: Return Boolean**/
        return returnValue;
    }
    
    /**
    * @author       :   IDC Offshore
    * @description  :   Creates User for those Contacts which are of PDI Admin Assistant RecordType.
    * @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
    * @return       :   N/A
    */ 
    public static void CreateAdminAssistantUsers(list<Contact> newContacts) {
        list<String> conIdList = new list<String>();
        list<String> aliasList = new list<String>();
        list<String> emailList = new list<String>();
        list<String> firstNameList = new list<String>();
        list<String> lastNameList = new list<String>();
        list<String> nickNameList = new list<String>();
        list<String> tempList = new list<String>();
        Map<Id, String> conId_FedId_map = new Map<Id, String>(); //PDI-Wave1 - Holds Contact Id and Employee ADID Value
        
        String alias;
        
        for(Contact loopContact: newContacts){
            
            conIdList.add(loopContact.Id);
            emailList.add(loopContact.Email);
            conId_FedId_map.put(loopContact.Id, loopContact.Employee_ADID__c); //PDI-Wave1 - Assign Contact Id and Employee ADID Value to conId_FedId_map
            
            if(loopContact.FirstName != null && loopContact.FirstName != '' && loopContact.LastName != null && loopContact.LastName != '') {
                alias = getAlias(loopContact.FirstName, loopContact.LastName);
            } else {
                tempList = loopContact.Email.split('@');
                if(tempList[0].length() > 8)    alias = tempList[0].subString(0,7);
                else alias = tempList[0];
            }
            
            aliasList.add(alias);
            
            if(loopContact.FirstName != null && loopContact.FirstName != '')    firstNameList.add(loopContact.FirstName);
            else firstNameList.add('FNU');
            
            if(loopContact.LastName != null && loopContact.LastName != '')  lastNameList.add(loopContact.LastName);
            else    lastNameList.add('LNU');
        }
        
        ManageCommunityUsers.createAdminAssistantUser(conIdList, aliasList, emailList, firstNameList, lastNameList, conId_FedId_map);
    }
    
    /**
    * @author       :   IDC Offshore
    * @description  :   Creates User for those Contacts which are of PDI Admin Assistant RecordType.
    * @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
    * @return       :   N/A
    */ 
    public static void createAdminAssistantUser(List<String> p_conIdList, List<String> p_aliasList, List<String> p_emailList, List<String> p_firstNameList, List<String> p_lastNameList, Map<Id, String> conId_FedId_map) {
        
        list<User> adidUserList = new list<User>(); //PDI-Wave1
        list<User> nonADIDUserList = new list<User>(); //PDI-Wave1
        list<User> userList = new list<User>();
        list<User> userSuccessList = new list<User>();
        list<User> userFailList = new list<User>();
        list<Contact> conList = new list<Contact>();
        
        set<Id> userSuccessConIdSet = new set<Id>();
        set<String> dupUserNameSet = new set<String>();
        set<String> dupCNickNameSet = new set<String>();
        map<id,string> contId_username_map = new map<id,string>();
        String tempNickName;
        string tempUserName;
        Database.SaveResult[] srList;
        Database.SaveResult[] srList1;
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        HandleFailedContacts hfcObj = new HandleFailedContacts();
        Integer i = 0;
        
        String qryStrUN = '';
        String qryStrCNN = '';
        String failRecordsErrHTMLStr = '';
        list<SystemException__c> sysExceptionList = new list<SystemException__c>();
        
        Id userProfileId = [select id, name from Profile where name = :CS_ManageProfile__c.getInstance('Communities_AdminAssistant').Profile_Name__c LIMIT 1].id;
        try {
            
            qryStrUN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
            qryStrCNN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
            for(String tempEMail: p_emailList) {
                qryStrUN = qryStrUN + '(Username like \'%'+tempEMail+'%\') OR ';
                qryStrCNN = qryStrCNN + '(CommunityNickname like \'%'+tempEMail+'%\' ) OR ';
            }
            qryStrUN=qryStrUN.substring(0,qryStrUN.lastIndexOf('OR')-1);
            qryStrCNN=qryStrCNN.substring(0,qryStrCNN.lastIndexOf('OR')-1);
            
            userList = database.query(qryStrCNN);
            for(User tempUser : userList)   dupCNickNameSet.add(tempUser.CommunityNickname);
            
            userList = database.query(qryStrUN);
            for(User tempUser : userList)  dupUserNameSet.add(tempUser.userName);
            
            /** @Description: Allowing of email whenever the user is inserted. **/
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = true;
            
            /** @Description: Creating New User's List**/
            userList = new list<User>();
            /** @Description New map with contact id and username **/
            map<id,string> contId_username_u_map = new map<id,string>();
            for(i = 0; i < p_conIdList.size(); i++) {
                
                tempNickName = p_emailList[i];//MP-Only Email part before @
                tempUserName = p_emailList[i];
                //tempNickName = tempNickName.subString(0,tempNickName.lastIndexOf('@'));
                tempNickName = mcuObj.getUniqueUnameOrCNickName(tempNickName,dupCNickNameSet,'nickname');
                //tempNickName = getnickName(tempNickName) + '.'+ tempNickName.subString(tempNickName.lastIndexOf('.')+1,tempNickName.length());
                dupCNickNameSet.add(tempNickName);
                tempUserName = mcuObj.getUniqueUnameOrCNickName(tempUserName,dupUserNameSet,'username');
                dupUserNameSet.add(tempUserName);
                String federationId = null;
                if(conId_FedId_map.get(p_conIdList[i]) != null){
                    federationId = conId_FedId_map.get(p_conIdList[i]) + Label.CL377_PDI_ADIDSuffix;
                }
                userList.add(new User(
                    alias = p_aliasList[i]
                    , email = p_emailList[i]
                    , CommunityNickname = tempNickName
                    , emailencodingkey = 'UTF-8'
                    , firstname = p_firstNameList[i]
                    , lastname = p_lastNameList[i]
                    , languagelocalekey = 'en_US'
                    , UserRoleId = null
                    , localesidkey = 'en_US'
                    , profileid = userProfileId
                    , contactId = p_conIdList[i]
                    , isActive = true
                    , timezonesidkey = 'America/Los_Angeles'
                    , username = tempUserName
                    , FederationIdentifier = federationId  //PDI-Wave1 : Getting ADID value based on contact Id from conId_FedId_map and assigning to FederationIdentifier field in User Object
                ));
                /** Post Production Enhancements ---Contact User Name Update **/
                contId_username_u_map.put(p_conIdList[i],tempUserName);
            }
            /** @Description: Inserting Users **/
            srList = Database.insert(userList, false);
            i=0;
            for(Database.SaveResult sr : srList){
                if(sr.isSuccess())  userSuccessList.add(userList[i]);
                else    userFailList.add(userList[i]);
                
                i = i + 1;
            }
            /** @Description: Trying to insert the failed records again **/
            srList1 = Database.insert(userFailList, false);
            i=0;
            for(Database.SaveResult sr : srList1){
                if(sr.isSuccess()) {
                    userSuccessList.add(userList[i]);
                } else {
                    hfcObj.addToFailList(userList[i],sr);
                }
                
                i = i + 1;
            }
            hfcObj.insertFailList();
            /** @Description: Updating the Portal User Flag on Contact Record for successfully created Users**/
            if(!userSuccessList.isEmpty()) {
                for(User tempUser : userSuccessList)    userSuccessConIdSet.add(tempUser.contactId);
                
                hfcObj.removeFromFailList(userSuccessConIdSet);
                conList = [SELECT id, Email, Is_Portal_User__c FROM Contact WHERE id IN :userSuccessConIdSet];
                for(Contact temp: conList)  temp.Is_Portal_User__c = true;
                /** Post Production Enhancements ---Contact User Name Update **/
                for(Contact temp: conList)  {
                    if (contId_username_u_map.containsKey(temp.id)){
                        temp.Username__c =  contId_username_u_map.get(temp.id);  //u.username;          
                    }
                }
                /** Contact User Name Update **/
                update conList;
            }
        } catch (Exception classException) { 
            String errStr = classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------';
            sysExceptionList.add(new SystemException__c(ExceptionMessage__c = errStr));
            insert sysExceptionList;
        }
    }
    /**
    * @author       :   IDC Offshore
    * @description  :   Updates email Id on User record which is on contact object.
    * @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
    * @return       :   N/A
    */ 
    public static void UpdateAdminAssistantUsers(list<Id> newContacts) {
        Map<Id,User> mapAdminAsstUsers=new map<Id,User>();
        List<Contact> lstContactUpdates=new List<Contact>();
        list<User> userList = new list<User>();
        list<Contact> conList = new list<Contact>();
        set<String> dupUserNameSet = new set<String>();
        String tempUserName;
        List<String> p_emailList=new List<String>();
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        Integer i = 0;
        String qryStrUN = '';
        
        List<Contact> lstProviderContacts=new List<Contact>([select id,Email,Username__c from Contact where id in:newContacts]);
        if(lstProviderContacts!=null && lstProviderContacts.size()>0)
        {
            for(Contact objContact:lstProviderContacts)
            {
                p_emailList.add(objContact.email);  
            }
            for(User objUser:[select id,email,username,contactid,isActive from user where contactid in:lstProviderContacts])
                mapAdminAsstUsers.put(objUser.contactid,objUser);// Fetcing the Users Related to the Contacts
        }
        qryStrUN = 'SELECT UserName, CommunityNickname FROM User WHERE ';
        for(String tempEMail: p_emailList) {
            qryStrUN = qryStrUN + '(Username like \'%'+tempEMail+'%\') OR ';
        }
        qryStrUN=qryStrUN.substring(0,qryStrUN.lastIndexOf('OR')-1);
        userList = database.query(qryStrUN);
        for(User tempUser : userList)  dupUserNameSet.add(tempUser.userName);
        for(Contact loopContact: lstProviderContacts){
            if(mapAdminAsstUsers.get(loopContact.id)!=null)
            {
                User objUser=  mapAdminAsstUsers.get(loopContact.id);        
                /* * If the Contact is of Teleform or Non TeleForm type and is not Resigned or Retired * */
                tempUserName = mcuObj.getUniqueUnameOrCNickName(loopContact.Email,dupUserNameSet,'username');//Fetching the Unique Username
                dupUserNameSet.add(tempUserName);
                loopContact.Username__c=tempUserName;// Copying the Unique Username in Contact's Username Field
                lstContactUpdates.add(loopContact);
            }  
        }
        if(lstContactUpdates!=null && lstContactUpdates.size()>0)
        {
            update lstContactUpdates;// Updating Contacts
            List<id> lstUpdatedContacts=new List<id>();
            for(Contact objCon:lstContactUpdates)
                lstUpdatedContacts.add(objCon.id);// Fetching the Id of the Updated contacts
            
            if(lstUpdatedContacts!=null && lstUpdatedContacts.size()>0){
                ManageCommunityUsers.UpdateAdminAssistantUsersRecords(lstUpdatedContacts);// Passing Id of Contacts whose User is also to be updated 
            }
        }
    }
    
    /**
    * @author       :   IDC Offshore
    * @description  :   Updates email Id and username on User record which is on contact object.
    * @param        :   List [Contacts] - Will always contain records which have a valid E-mail ID
    * @return       :   N/A
    */ 
    @future
    public static void UpdateAdminAssistantUsersRecords(list<Id> lstUpdatedContacts) {
        Map<Id,User> mapAdminAssistantUsers=new map<Id,User>();
        List<Contact> lstContacts;
        List<User> lstUsersToUpdate=new List<User>();
        ManageCommunityUsers mcuObj = new ManageCommunityUsers();
        
        if(lstUpdatedContacts!=null && lstUpdatedContacts.size()>0)
        {
            // Fetching Users related to the Updated Contacts.
            lstContacts=new List<Contact>([select id,Username__c,email from Contact where id in :lstUpdatedContacts]);
            for(User objUser:[select id,email,username,CommunityNickname,contactid,isActive from user where contactid in:lstUpdatedContacts])
                mapAdminAssistantUsers.put(objUser.contactid,objUser);// Fetcing the Users Related to the Contacts
            
            for(Contact objContact:lstContacts)
            {
                if(mapAdminAssistantUsers.get(objContact.id)!=null)  //checking if we are getting the Related user to the current Contact in the loop.
                {
                    User objUsr=mapAdminAssistantUsers.get(objContact.id);
                    // Updating the Users's Username and Email 
                    objUsr.username=objContact.username__c;
                    objUsr.email=objContact.Email;
                    lstUsersToUpdate.add(objUsr);   
                }   
            }
            if(lstUsersToUpdate!=null && lstUsersToUpdate.size()>0){ update lstUsersToUpdate; } // Updating Users
        }
    }
}