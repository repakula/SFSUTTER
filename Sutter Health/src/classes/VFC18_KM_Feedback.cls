/**  
*     Class Name  : VFC18_KM_Feedback
*     Author      : Atul Gupta
*     Date        : 30-July-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Release 6 Req-2899 KM Feedback Page extension class
*    VERSION    AUTHOR              DATE        DETAIL 
*      1.0     Umesh Vajpai      July 7, 2016    Added code for KM_Feedback_Community
**/
public class VFC18_KM_Feedback extends SH_BaseController{

public list<wrapArticleData> lstSuggestedArticles {get; set;}
  public string showPnl {get;set;}
    public boolean showSuggestedArticlePnl {get; set;}
     public string activePgName {get; set;}
    /** Description: Static integer values used in Blacklist methods
    **/
    public static Integer FEED_POST = 1;
    public static Integer FEED_COMMENT = 2;
    public static Integer USER_STATUS = 3;
    
    /** Description: Variables for strings used in Class
    **/
    public static final String ARTICLE_NUMBER = 'articleNumber';
    public static final String ARTICLE_TYPE = 'articleType';
    public static final String FUNCTIONAL_AREA = 'Functional_Area__c';
    public static final String SUB_FUNCTION = 'Sub_Function__c';
    
    /** Description: boolean variable check error
    **/
    public boolean closeWindowKM{get; set;}
    
    public boolean thankYouBlock{get; set;}
    
    /** Description: Article Name displayed on the Page
    **/
    public String articleName{get; set;}
    
    List<PatternHelper> patterns {set; get;} 
    
    Map<Id, PatternHelper> matchedPosts {set; get;}
    
    /** Description: variable for Standard Controller
    **/
    private ApexPages.StandardController controller {get; set;}
    
    /** Description: map to hold KM Feedback custom setting values
    **/
    private Map<String, KMFeedback__c> kmFeedbackCustSettingMap;
     
    /** Description: variable to hold the km feedback record
    **/
    public KM_Feedback_Item__c km_Feedback{get;set;}
    
    /** Description: string variable to store article number
    **/
    public String artNum {get;set;}
    public string strArticleId {get;set;}
    
    /** Description: string variable to store article type
    **/
    public String artType {get;set;}
    
    private sObject km;
    
    
    
    /*********************************Empty Constructor************************************************/
    public VFC18_KM_Feedback()
    {
         patterns = new List<PatternHelper>();
         matchedPosts = new Map<Id, PatternHelper>(); 
         preparePatterns();
         closeWindowKM = false;
        Initialize();
    }
    
/*******************************************************************
    Purpose: This method initializes the controller attributes
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    
    public void Initialize() {
        strArticleId = ApexPages.currentPage().getParameters().get('id');
        showPnl = '';

        artNum = ApexPages.currentPage().getParameters().get(ARTICLE_NUMBER);
        artType = ApexPages.currentPage().getParameters().get(ARTICLE_TYPE);

        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Article Feedback';
        setBreadCrumbs(); 

        //BreadCrumbs.add(new SH_BreadCrumb('Article Feedback' , '#'));

        lstSuggestedArticles = new list<wrapArticleData>();
        showSuggestedArticlePnl = false;
        closeWindowKM = false;
        thankYouBlock = false;

        this.km_Feedback = new KM_Feedback_Item__c();

    }
        
    /*********************************Standard Controller Constructor************************************************/
    public VFC18_KM_Feedback(ApexPages.StandardController controller) 
    {
        try{
            
            this.controller = controller;
            
            /** Description: typecast km feedback record to km feedback variable
            **/
            this.km_Feedback = (KM_Feedback_Item__c)controller.getRecord();
            
            /** Description: capture query string parameters i.e. article number and article type
            **/
            artNum = ApexPages.currentPage().getParameters().get(ARTICLE_NUMBER);
            artType = ApexPages.currentPage().getParameters().get(ARTICLE_TYPE);
            
            /** Description: set default value for the variable
            **/
            closeWindowKM = false;
            thankYouBlock = false;
            Initialize();
            system.debug('@@constructor');
         /** Description: catch statement to capture any errors in the code, show a message on the page and log as a record in system exceptions object
         **/   
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    
    /*******************************************************************
    Purpose: This method queries the article attributes
    Parameters: None
    Returns: none 
    Throws [Exceptions]: classException
    ********************************************************************/
    public void articleQueryMethod()
    {
        try{
            artNum = ApexPages.currentPage().getParameters().get(ARTICLE_NUMBER);
            artType = ApexPages.currentPage().getParameters().get(ARTICLE_TYPE);
            /** Description: Query string to fetch relevant fields from the article type and article number
            **/
            String articleQuery = 'SELECT Id, KnowledgeArticleId, Title, UrlName, Functional_Area__c, Sub_Function__c FROM ' + artType + ' where ArticleNumber=\'' + artNum  + '\' AND publishstatus= \'online\' AND language = \'en_US\'';
            system.debug('@@articleQueery : '+ articleQuery);
            /** Description: execute the query and store in an sObject variable
            **/
            km = Database.query(articleQuery);
            
            articleName = String.valueOf(km.get('Title'));
            strArticleId = String.valueOf(km.get('KnowledgeArticleId')); 
            
            BreadCrumbs.add(new SH_BreadCrumb(articleName , 'SH_ArticleView?id='+strArticleId));
            BreadCrumbs.add(new SH_BreadCrumb('Article Feedback' , '#'));
            
        /** Description: catch statement to capture any errors in the code, 
         *   show a message on the page and log as a record in system exceptions object
         **/
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
    }
    
    
    /*******************************************************************
    Purpose: This method sets the flag on Cancel Button Click 
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    public Pagereference cancel()
    {
        closeWindowKM = true;
        return null;
    }
    
    
    /*******************************************************************
    Purpose: Save method that fetches values from the Article record and insert it in the KM Feedback record
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    public Pagereference Save()
    {
        /** Description: fetch all the Custom Setting values
        **/
        kmFeedbackCustSettingMap = KMFeedback__c.getAll();
        
        /** Description: String variable for username username
        **/ 
        String userNameStr = '';
        
        /** Description: String variable for id of the user or queue as owner of the record
        **/
        Id assignedId;
        
        try{
            
            /** Description: pass relevant field values into the KM Feedback record
            **/
            if(!Test.isRunningTest()){            
                
                km_Feedback.Article_Title__c = String.valueOf(km.get('Title'));
                
                km_Feedback.Article_URL__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(km.get('KnowledgeArticleId'));
            
                /** Description: check if functional area field on article is blank
                **/
                if(String.isNotBlank(String.valueOf(km.get(FUNCTIONAL_AREA))))
                {
                    km_Feedback.Functional_Area__c = String.valueOf(km.get(FUNCTIONAL_AREA));
                } 
                
                /** Description: check if sub-funciton field on article is blank
                **/
                if(String.isNotBlank(String.valueOf(km.get(SUB_FUNCTION))))
                {
                    km_Feedback.Sub_Function__c = String.valueOf(km.get(SUB_FUNCTION));
                }
            }                
            
            km_Feedback.Reported_By__c = UserInfo.getUserId();
            km_Feedback.Reported_On__c = system.today();
            
            /** Description: iterate over custom setting values to fetch username from KMFeedback custom settings on the basis of the 
            *   functional area and sub-function fields
            **/
            for(KMFeedback__c kmfeedCustSett : kmFeedbackCustSettingMap.values())
            {
                /** Description: if funcional area and sub-function is not blank and matches a record in custom setting
                **/
                if(String.isNotBlank(km_Feedback.Functional_Area__c) && kmfeedCustSett.Functional_Area__c == km_Feedback.Functional_Area__c
                    && String.isNotBlank(km_Feedback.Sub_Function__c) && kmfeedCustSett.Sub_Function__c == km_Feedback.Sub_Function__c)
                {
                    /** Description: if KM champion username custom setting value is not blank
                    **/
                    if(String.isNotBlank(kmfeedCustSett.KM_Champion_Username__c))
                    {
                        /** Description: assign the km champion usename value to username string variable
                        **/
                        userNameStr = kmfeedCustSett.KM_Champion_Username__c;
                    }
                }
                
                /** Description: else condition to check if function area is not blank and sub-function is blank
                **/
                else if(String.isNotBlank(km_Feedback.Functional_Area__c) && kmfeedCustSett.Functional_Area__c == km_Feedback.Functional_Area__c
                       && String.isBlank(kmfeedCustSett.Sub_Function__c))
                {
                    /** Description: if KM champion username custom setting value is not blank
                    **/
                    if(String.isNotBlank(kmfeedCustSett.KM_Champion_Username__c))
                    {
                        /** Description: assign the km champion usename value to username string variable
                        **/
                        userNameStr = kmfeedCustSett.KM_Champion_Username__c;
                    }
                } 
            }
            
            /** Description: if username is not blank
            **/
            if(String.isNotBlank(userNameStr))
            {
                /** Description: query user id on the basis of username
                **/
                List<User> userRecordList = [Select Id, EmployeeAffiliate__c, Profile.Name from User where username =:userNameStr];
                system.debug('@@userList : '+ userRecordList);
                if(!userRecordList.isEmpty())
                {
                    system.debug('@@inside if :');
                    assignedId = userRecordList[0].id;
                    
                    if(String.isNotBlank(userRecordList[0].EmployeeAffiliate__c))
                    {
                        km_Feedback.Affiliate__c = userRecordList[0].EmployeeAffiliate__c; 
                    }
                }
                
                /** Description: query KM Feedback queue id
                **/
                else
                {
                    assignedId = [SELECT Id FROM Group where Type = 'Queue' AND DeveloperName = 'KM_Feedback'].Id;
                }
            }
            
            /** Description: query KM Feedback queue id
            **/
            else
            {
                assignedId = [SELECT Id FROM Group where Type = 'Queue' AND DeveloperName = 'KM_Feedback'].Id;
            }
            
            /** Description: if assignee id is not null, assign it to the owner field
            **/
            if(assignedId != null)
            {
                km_Feedback.OwnerId = assignedId;
            }
            
            /** Description: query login user's profile name
            **/
            String profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()].Name;
            km_Feedback.Submitter_Profile__c = profileName;
            
            /** Description: save KM feedback record
            **/
            insert km_Feedback;
            
            /** Description: if there is an error pagereference is return null
            **/
            if(km_Feedback == null)
            {
                closeWindowKM = false;
                thankYouBlock = false;
            }
            
            /** Description: else pagereference is returned with a value
            **/
            else
            {
                closeWindowKM = true;
                thankYouBlock = true;
            }
         /** Description: catch statement to capture any errors in the code, 
         *   show a message on the page and log as a record in system exceptions object
         **/
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
            Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
        /** Description: return null
        **/
        return null;
    }
    
    
   /*******************************************************************
    Purpose: Prepares a list of  blacklist words and their patterns
    Parameters: None
    Returns: none 
    Throws [Exceptions]: None
    ********************************************************************/
    private void preparePatterns()
    {
        List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                            Add_to_Compliance_Audit__c, Custom_Expression__c,
                                            Prevent_Post_on_Breach__c
                                         from Blacklisted_Word__c where is_Active__c = true];
    
        for(Blacklisted_Word__c bwc : bwWords)
        {
            patterns.add(new PatternHelper(bwc));
        }
        
    }
    
    
    /*******************************************************************
    Purpose: Given a list of KM Feedback Items, filter them against the blacklisted words
    Parameters: None
    Returns: List<KM_Feedback_Item__c> 
    Throws [Exceptions]: None
    ********************************************************************/
    public List<KM_Feedback_Item__c> filterKMFeedbackItems(List<KM_Feedback_Item__c> km)
    {
        return filterFeedbackforKMFeedbackItem(km);
    }
    
    
    /*******************************************************************
    Purpose: Helper method of filterKMFeedbackItems
    Parameters: None
    Returns: List<KM_Feedback_Item__c> 
    Throws [Exceptions]: None
    ********************************************************************/
    private List<KM_Feedback_Item__c> filterFeedbackforKMFeedbackItem(List<KM_Feedback_Item__c> sobjs)
    {
        List<KM_Feedback_Item__c> updatedSobjs = new List<KM_Feedback_Item__c>();
        
        Matcher m;
        String body = null;
    
         for (KM_Feedback_Item__c f : sobjs)
         {
                boolean preventPost = false;
                String matchedWord = 'REGEX';
                body = f.Feedback__c;
                
                
                for(PatternHelper ph : patterns)
                {
                     Matcher myMatcher = ph.p.matcher(body);
                      
                       if(myMatcher.find())
                       {
                             body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                             
                              if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                              {
                                          ph.origPostBody = f.Feedback__c;
                                          //System.debug('ADDING ORIG POST BODY:'+ph.origPostBody);
                                          ph.postCreatedById = f.createdById;
                                          matchedPosts.put(ph.blacklistedWord.id, ph);
                              }
                              
                             //only need to set one message per breach - on the first breach
                             if(ph.preventPostOnMatch)
                             {
                                //System.debug('PH PREVENTING WITH WORD:'+ph.blacklistedWord.Word__c);
                                 if(!String.isEmpty(ph.blacklistedWord.Custom_Expression__c))
                                        matchedWord = 'Custom Regular Expression';
                                  else
                                        matchedWord = ph.blacklistedWord.Word__c;   
                                  preventPost = true; 
                                  break;
                             }
                       }
                 }
                
             
                  
                if(preventPost)
                {
                    closeWindowKM = false;
                    f.addError('Post prevented due to use of a blacklisted word: '+matchedWord);
                }
                else
                {
                        f.Feedback__c = body;
                        closeWindowKM = true;        
                }
                updatedSobjs.add(f);
         }
         
          doAudit();
         
         return updatedSobjs;
    }
    

    /*******************************************************************
    Purpose: Take the matched posts, serialize them (so we can send them to a future method), and async to insert into audit table
             This allows us to insert audits even if the feed item transaction rolls back
    Parameters: None
    Returns: None 
    Throws [Exceptions]: None
    ********************************************************************/
    private void doAudit()
    {
        List<String> serializedPH = new List<String>();
    
        for(PatternHelper p : matchedPosts.values())
        {
            serializedPH.add(JSON.serialize(p.getSerializable()));
        }
        //System.debug('FIRING FUTURE WITH THIS MANY RECORDS:'+serializedPH.size());
        doAuditFuture(serializedPH);
    }
    
    
    /*******************************************************************
    Purpose: If a blacklisted word is flagged as save to audit, lets write it to the blacklist audit list.
              Accepts a serialized list of pattern helpers.
    Parameters: None
    Returns: None
    Throws [Exceptions]: None
    ********************************************************************/ 
    @future
    static void doAuditFuture(List<String> mposts)
    {
        //System.debug('IN AUDIT FUTURE');
        List< Blacklist_Audit__c> audits = new List<Blacklist_Audit__c>();
        Blacklist_Audit__c blaudit = null;
        PatternHelperSerializable p = null;
     
       //deserialize and work with pattern helper
       for (String ser : mposts)
       {
        //System.debug('JSON:'+ser);
          p = (PatternHelperSerializable) JSON.deserialize(ser, PatternHelperSerializable.class);
           
           //check for audit actions
            if(p.blacklistedWord.Add_to_Compliance_Audit__c)
            {
                //System.debug('FOUND AN AUDIT MATCH. ORIG POST:'+p.origPostBody);
               blaudit = new Blacklist_Audit__c();
               blaudit.Breached_By__c = p.postCreatedById;
               blaudit.Unscrubbed_Post__c = p.origPostBody;
             
               if(p.blacklistedWord.Custom_Expression__c != NULL)
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Custom_Expression__c;
               else
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Word__c;
              
               audits.add(blaudit);
            }
            
            //check for notifier actions
            //TODO
        }
        
        if(!audits.isEmpty())
        {
            //System.debug('GOT SOME AUDITS TO ADD');
            Database.SaveResult[] srList = Database.insert(audits);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Blacklist fields that affected this error: ' + err.getFields());
                    }
                }
            } 
        }     
    }
    
    /************************************Wrapper Class******************************/
    public class wrapArticleData {
        public string strTitle {get;set;}
        public string strArticleId {get; set;}
        
        public wrapArticleData(string title, string articleId) {
            this.strTitle = title;
            this.strArticleId = articleId;
        }
    }
    
    /*******************************************************************
    Purpose: Was this article helpful? options.
    Parameters: None
    Returns: List<SelectOption>
    Throws [Exceptions]: None
    ********************************************************************/ 
    public List<SelectOption> getArticleOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
   }
}