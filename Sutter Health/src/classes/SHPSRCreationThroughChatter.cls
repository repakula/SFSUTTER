/**    
 *     Class Name  : SHPSRCreationThroughChatter
 *     Author      : IDC Offshore  
 *     Date        : 20-Oct-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : SHPSRCreationThroughChatter is helper class for Trigger to insert a SR based on specific format detected
 *                   in the body of the post shared in Chatter.                      
 **/
public Class SHPSRCreationThroughChatter { 
    public static String RECTYPENAME = 'SHP Chatter SR - Service';
    public static String COLAN = ':';
    public static String EXTERNALPROFILEID = System.Label.SHP_Chatter_External_Profile_Id;
    private static final string EXEPTION_MSG1 = '--------------';
    private static final string EXEPTION_MSG = '\r\n';
    
    // Req 3388 Chatter Internal Collaboration Sales :- Varibale declation to identify Employer/Broker/Member Contact Ids in the Post- Start
    public static String EMPLOYERKER = 'Employer';
    public static String BROKERKEY = 'Broker';
    public static String MEMBERKEY = 'Member';
    public static String EMPLOYERRECTYPE = 'SHP Sales Employer Contact';
    public static String EMPLOYERRORECTYPE = 'SHP Sales Employer Contact Read Only';
    public static String EMPLOYERPATTERN = '[0-9]{5}[0-9]';
    public static String MEMBERPATTERN = '[M|m][0-9]{8}[-][0-9]{2}';
    public static String BROKERPATTERN = '[C|c][-][0-9]{7}[0-9]';
    // Req 3388 Chatter Internal Collaboration Sales :- Varibale declation to identify Employer/Broker/Member Contact Ids in the Post - End
    
    
    // Req 3388 Chatter Internal Collaboration Sales :- Methods to identify Employer/Broker/Member Contact Id's Patterns in the Post - Start
    /**
    *   @Description: Methods Extracts Employer Id From Post Body of  Chatter Posts containing Employer Id.
    *   @Arguments: String PostBody     
    *   @Return: String ContactId 
    **/
    public static String extractContactUniqueId( String PostBody ) {
        String ContactUniqueId;
        PostBody = PostBody.stripHtmlTags();
        Pattern EmployerIdPattern = Pattern.compile(EMPLOYERPATTERN);
        Matcher IdMatchOfEmployer = EmployerIdPattern.matcher(PostBody);
        if( IdMatchOfEmployer.find() ) {
            ContactUniqueId = IdMatchOfEmployer.group(0);
        }
        if( !String.isEmpty(ContactUniqueId) ) {
            return ContactUniqueId;
        }
        return null;    
    }
    
    /**
    *   @Description: Methods Extracts Broker Id From Post Body of  Chatter Posts containing BrokerId Id.
    *   @Arguments: String PostBody     
    *   @Return: String ContactId 
    **/
    public static String extractBrokerContactId( String PostBody ) {
        String BrokerUniqueId;
        PostBody = PostBody.stripHtmlTags();
        Pattern BrokerIdPattern = Pattern.compile(BROKERPATTERN);
        Matcher IdMatchOfBroker = BrokerIdPattern.matcher(PostBody);
        if( IdMatchOfBroker.find() ) {
            BrokerUniqueId = IdMatchOfBroker.group(0);
        }
        if( !String.isEmpty(BrokerUniqueId) ) {
            return BrokerUniqueId;
        }
        return null;
    }
    
    /**
    *   @Description: Methods Extracts Member Id From Post Body of  Chatter Posts containing Member Id.
    *   @Arguments: String PostBody     
    *   @Return: String ContactId 
    **/
    public static String extractMemberContactId( String PostBody ) {
        String ContactUniqueId;
        PostBody = PostBody.stripHtmlTags();
        Pattern MemberIdPattern = Pattern.compile(MEMBERPATTERN);
        Matcher IdMatchOfMember = MemberIdPattern.matcher(PostBody);
        if( IdMatchOfMember.find() ) {
            ContactUniqueId = IdMatchOfMember.group(0);
        }
        if( !String.isEmpty(ContactUniqueId) ) {
            return ContactUniqueId;
        }
        return null;
    }
   // Req 3388 Chatter Internal Collaboration Sales :- Methods to identify Employer/Broker/Member Contact Id's Patterns in the Post - End
    
    
    /**
    *   @Description:Method Detects Keywords related to SR Creation and identifies Contact Id, 
    *                and Creates SR for for that Chatter Post , Extract contact Id from Chatter Post body,
    *                Query the related Contact and attach it to the SR and inserted SR in the system is shared with 
    *                the user who posted Chatter Post using apex sharing. 
    *   @Arguments: List <FeedItem> InsertedFeedItemList     
    *   @Return: void 
    **/
    public static void createSHPSRFromChatter( List <FeedItem> InsertedFeedItemList ) {
        Map< String, SHP_SR_Creation_From_Chatter__c > ChatterKeywordCustomSettingMap = new Map< String, SHP_SR_Creation_From_Chatter__c > ();
        Map<String, SHP_SR_Creation_From_Chatter__c> KeywordCustomSettingMapOfChatter = SHP_SR_Creation_From_Chatter__c.getAll();
        
      /*
       * @Description: Populate the map of all the Queue Keywords Custome Setting Id and Custom setting. 
       */
        for ( SHP_SR_Creation_From_Chatter__c  chatterKeyword: KeywordCustomSettingMapOfChatter.values() ) {
            ChatterKeywordCustomSettingMap.put( chatterKeyword.Id, chatterKeyword );
        }
        
        List < Case > SHPSRListToInsert = new List<Case> ();
        List < FeedItem > SRRelatedFeedItems = new List < FeedItem > ();
        List<String> ContactIdList = new List<String>();
        List<String> EmployerIdList = new List<String>();
        Map<String, Contact > MemberIdContactMap = new Map <String, Contact>();
        Map<String, Contact > EmployerIdContactMap = new Map < String, Contact>();
        Id EMPLOYERRECTYPEID = Schema.SObjectType.Contact.RecordTypeInfosByName.get(EMPLOYERRECTYPE).RecordTypeId;
        Id EMPLOYERRORECTYPEID = Schema.SObjectType.Contact.RecordTypeInfosByName.get(EMPLOYERRORECTYPE).RecordTypeId;
       
      /*
       * @Description:Check if Queue keyword is present in the post being inserted and collect the contact related Ids from 
       *              post body and store them in the List.
       */
        try {
        // Req 3388 Chatter Internal Collaboration Sales :- Logic Change to Identify Employer/Broker/Member Contact Ids from Chatter Post using above mentioned methods and attach the respective Contact to the Chatter SR - Start 
            for ( FeedItem InsertedPost : InsertedFeedItemList ) {
                for( SHP_SR_Creation_From_Chatter__c  chatterKeyword: ChatterKeywordCustomSettingMap.values()) {
                    if( InsertedPost.Body.containsIgnoreCase(ChatterKeywordCustomSettingMap.get(chatterKeyword.Id).Name) && InsertedPost.Body.containsIgnoreCase(MEMBERKEY) && !( InsertedPost.Body.containsIgnoreCase(BROKERKEY) || InsertedPost.Body.containsIgnoreCase(EMPLOYERKER) ) ) {
                        String PostBody = InsertedPost.Body;
                        String ContactUniqueId = extractMemberContactId( PostBody );
                        if( !String.isBlank(ContactUniqueId) ) {
                            ContactIdList.add(ContactUniqueId);
                        }
                    }
                
                    if(InsertedPost.Body.containsIgnoreCase(ChatterKeywordCustomSettingMap.get(chatterKeyword.Id).Name) && InsertedPost.Body.containsIgnoreCase(BROKERKEY) && !(InsertedPost.Body.containsIgnoreCase(MEMBERKEY) || InsertedPost.Body.containsIgnoreCase(EMPLOYERKER))) {
                        String PostBody = InsertedPost.Body;
                        String ContactUniqueId = extractBrokerContactId( PostBody );
                        if( !String.isBlank(ContactUniqueId) ) {
                            ContactIdList.add(ContactUniqueId);
                        }
                    }
                
                    if(InsertedPost.Body.containsIgnoreCase(ChatterKeywordCustomSettingMap.get(chatterKeyword.Id).Name) && InsertedPost.Body.containsIgnoreCase(EMPLOYERKER) && !(InsertedPost.Body.containsIgnoreCase(MEMBERKEY) || InsertedPost.Body.containsIgnoreCase(BROKERKEY))) {
                        String PostBody = InsertedPost.Body;
                        String ContactUniqueId = extractContactUniqueId( PostBody );
                        if( !String.isBlank( ContactUniqueId )) {
                            EmployerIdList.add(ContactUniqueId);
                        }       
                    }
                }
            }
        
          /*
           * @Description:Query the Contacts from the above Idlist and populate the Map of contact Id and Contact Object.  
           *              
           */
            if( !ContactIdList.isEmpty()) {
                for ( Contact con:[ Select Id, Member_ID__c,HealthRules_ID__c FROM Contact WHERE Member_ID__c IN :ContactIdList OR HealthRules_ID__c IN :ContactIdList limit 1]) {
                    if( con.Member_ID__c != null ) {
                        MemberIdContactMap.put( con.Member_ID__c , con );
                    }else if( con.HealthRules_ID__c != null ) {
                        MemberIdContactMap.put( con.HealthRules_ID__c , con);
                    }
                }
            }
    
           /*
           * @Description:Query the Employe Contacts from the above Idlist and populate the Employer Map of contact Id and Contact Object.  
           *              
           */ 
            if( !EmployerIdList.isEmpty() ) {
                for (Contact EmpCon :[SELECT Id,Account.SHP_Group_ID__c, LastModifiedDate  FROM Contact WHERE Account.SHP_Group_ID__c =:EmployerIdList[0] AND (RecordTypeId = :EMPLOYERRECTYPEID OR RecordTypeId = :EMPLOYERRORECTYPEID) ORDER BY LastModifiedDate DESC NULLS LAST limit 1]) {
                    if( EmpCon != null && EmpCon.Account.SHP_Group_ID__c != null ) {
                        EmployerIdContactMap.put( EmpCon.Account.SHP_Group_ID__c , EmpCon );
                    }
                }
            }
      
          /*
           * @Description:For every inserted post in the system Create a SR of Chatter recordtype if the Queue keywords are present in the body of the 
           *              the post and attach the contact fetched related to unique Id present in the body and attch the post to the SR. 
           *              
           */
            for( FeedItem InsertedPost : InsertedFeedItemList ) {
                Integer SRCounter = 0;
                for ( SHP_SR_Creation_From_Chatter__c chatterKeyword : ChatterKeywordCustomSettingMap.values() ) {
                    if( InsertedPost.Body.containsIgnoreCase(ChatterKeywordCustomSettingMap.get(chatterKeyword.Id).Name) &&  SRCounter == 0 ) {
                        String PostBody = InsertedPost.Body;
                        PostBody = PostBody.stripHtmlTags();
                        String ContactUniqueId;
                        String EmployerUniqueId;
                    
                        if( InsertedPost.Body.containsIgnoreCase(MEMBERKEY) && !(InsertedPost.Body.containsIgnoreCase(EMPLOYERKER) || InsertedPost.Body.containsIgnoreCase(BROKERKEY)) ) {
                            ContactUniqueId = extractMemberContactId(PostBody);
                        }
                    
                        if( InsertedPost.Body.containsIgnoreCase(BROKERKEY) && !(InsertedPost.Body.containsIgnoreCase(EMPLOYERKER) || InsertedPost.Body.containsIgnoreCase(MEMBERKEY) ) && String.isEmpty(ContactUniqueId) ) {
                            ContactUniqueId = extractBrokerContactId( PostBody );
                        }
                    
                        if( InsertedPost.Body.containsIgnoreCase(EMPLOYERKER) && !(InsertedPost.Body.containsIgnoreCase(BROKERKEY) || InsertedPost.Body.containsIgnoreCase(MEMBERKEY) ) && String.isEmpty(ContactUniqueId) ) {
                            EmployerUniqueId= extractContactUniqueId( PostBody );
                        }
                        Case CaseToInsert = new Case ( Origin = System.label.LABS_SF_Chatter,
                                                    Status = System.label.cl_CaseTrigger_New_Status,
                                                    RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(RECTYPENAME).RecordTypeId,
                                                    OwnerId = ChatterKeywordCustomSettingMap.get(chatterKeyword.Id).Queue_Id__c,
                                                     Description = PostBody);
                        if( !String.isEmpty(ContactUniqueId) && !MemberIdContactMap.isEmpty() && MemberIdContactMap.containsKey( ContactUniqueId )) {
                            CaseToInsert.ContactId = MemberIdContactMap.get(ContactUniqueId).Id;
                        }
                        if( !String.isEmpty(EmployerUniqueId) && !EmployerIdContactMap.isEmpty() && EmployerIdContactMap.containsKey(EmployerUniqueId)) {
                            CaseToInsert.ContactId = EmployerIdContactMap.get(EmployerUniqueId).Id;
                        }
                        SHPSRListToInsert.add(CaseToInsert);
                        SRRelatedFeedItems.add( InsertedPost);
                        SRCounter = SRCounter +1;
                    }   
                }
            }
        // Req 3388 Chatter Internal Collaboration Sales :- Logic Change to Identify Employer/Broker/Member Contact Ids from Chatter Post using above mentioned methods and attach the respective Contact to the Chatter SR - End
        
            if( !SHPSRListToInsert.isEmpty() ) {
                Database.insert( SHPSRListToInsert );
                List< CaseShare > SRShareListToInsert = new List< CaseShare >();
                String ExternalProfileIdValue = UserInfo.getProfileId();
                
                for ( Integer i=0 ; i < SHPSRListToInsert.size() ; i++ ) {
                    SRRelatedFeedItems[i].ParentId = SHPSRListToInsert[i].Id;
                }
                
                if( !(ExternalProfileIdValue.contains(EXTERNALPROFILEID))) {
                    for ( Case insertedSR : SHPSRListToInsert ) {
                        if( insertedSR.id != null ) {
                            CaseShare SRShare  = new CaseShare();
                            SRShare.CaseId = insertedSR.id;
                            SRShare.UserOrGroupId = UserInfo.getUserId();
                            SRShare.CaseAccessLevel  = 'Read';
                            SRShare.RowCause = Schema.CaseShare.RowCause.Manual;
                            SRShareListToInsert.add(SRShare);
                        }
                    }
                    
                    if( !SRShareListToInsert.isEmpty() ) {
                        Database.insert(SRShareListToInsert);
                    }
                }
            }
        }catch ( Exception CodeEx ) {
            Utility.handleExceptionFromCode(CodeEx.getMessage() + EXEPTION_MSG + CodeEx.getStackTraceString() + EXEPTION_MSG  + CodeEx.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }   
    }
}