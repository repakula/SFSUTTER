/**  
*     Class Name  : VFC18_KM_Feedback_Test
*     Author      : IDC Offshore
*     Date        : 11-Aug-2014
*     Project Name: CRM - SFT - Sutter Health
*     Description : Test Class for VFC18_KM_Feedback ,PatternHelper,PatternHelperSerializable Class and KMFeedBackInsertUpdate Trigger . This class tests different scenarios that are handled in the code
**/

@isTest
private class VFC18_KM_Feedback_Test {
    
    static VFC18_KM_Feedback km_ext;
    static KM_Feedback_Item__c km_record;
    static string pageURL;
    
    /**
    * @author IDC Team             
    * @date 26/Oct/2015            
    * @description: @testSetup method to create test data used by all tests    
    * @param       
    * @return void 
    **/ 
    
    @testSetup 
    static void createTestData() 
    {
        //Create a new KMFeedback custom setting record. 
        KMFeedback__c kmfeedCustSett = new KMFeedback__c();        
        kmfeedCustSett.Name = 'Test001';        
        kmfeedCustSett.Functional_Area__c = 'Finance';        
        kmfeedCustSett.Sub_Function__c = 'General Inquiry';        
        kmfeedCustSett.KM_Champion_Username__c ='kmtest@sutterhealth.org';  
        kmfeedCustSett.KM_Champion__c = 'Test KM';
        insert kmfeedCustSett ;
        
        //Assert to check if custom setting record has been created successfully 
        system.assert(kmfeedCustSett.id != null);
        
        // create test user 
        Profile p = [SELECT Id FROM Profile WHERE Name='S3 Supply Chain Agent']; 
        User usr = new User(Alias = 'flexuser',Email='flexuser@fakeemail.com',EmailEncodingKey='UTF-8',EmployeeAffiliate__c='yes', LastName='ut1@testorg.com', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='kmtest@sutterhealth.org');
        insert usr; 
        
        //Assert to check if User has been created successfully 
        system.assert(usr.id != null);
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        //Assert to check if Account has been created successfully 
        system.assert(acc.id != null); 
        
        Contact cont = new Contact(AccountId = acc.id, LastName = 'Contact Name');
        insert cont;
        
        //Create test article and publish it
        FAQ__kav testFaq = new FAQ__kav();
        testFaq.Title = 'Test FAQ';
        testFaq.Summary = 'KB Summary';
        testFaq.URLName = 'FAQ-TestArticle';
        insert testFaq;
        
        //Assert to check if article has been created successfully 
        testFaq = [SELECT Id, ArticleNumber,KnowledgeArticleId, Title, UrlName, Functional_Area__c, Sub_Function__c FROM FAQ__kav where publishstatus= 'Draft' AND language = 'en_US' and Title = 'Test FAQ'];
        System.assertEquals(testFaq.title, 'Test FAQ');
        
        //publish the article
        KbManagement.PublishingService.publishArticle(testFaq.KnowledgeArticleId, false);
        
        //Assert to check whether article has been published successfully.
        testFaq = [SELECT Id, ArticleNumber,KnowledgeArticleId, Title, UrlName, Functional_Area__c, Sub_Function__c FROM FAQ__kav where publishstatus= 'Online' AND language = 'en_US' and Title = 'Test FAQ'];
        System.assertEquals(testFaq.title, 'Test FAQ');
        
        // insert KM feedback item 
        KM_Feedback_Item__c km1 = new KM_Feedback_Item__c(Status__c = 'New',Due_Date__c = date.today(),Feedback__c='facebook',Feedback_Reason__c = 'URL',Type_of_feedback__c='URL Issue');
        insert km1;
    }

    /**
    * @author IDC Team
    * @date 31/07/2014
    * @description: init method that query on knowledge article and set articleType ,articleNumber and page URL used in test methods
    * @param 
    * @return void
    */
    private static void init() {
      
        FAQ__kav testArticle = [SELECT Id, ArticleNumber, Title, UrlName, Functional_Area__c, Sub_Function__c FROM FAQ__kav where publishstatus= 'online' AND language = 'en_US' and Title = 'Test FAQ'];
        
        //Assert to check article number 
        System.assert(testArticle.ArticleNumber!= null ); 
       
        km_record = new KM_Feedback_Item__c();   
        ApexPages.currentPage().getParameters().put('articleType', 'FAQ__kav' ); 
        ApexPages.currentPage().getParameters().put('articleNumber', testArticle.ArticleNumber);
        pageURL = 'apex/VFP18_KM_Feedback?articleNumber=' + testArticle.ArticleNumber + '&articleType=FAQ__kav';
    }

    /**
    * @author IDC Team
    * @date 11/08/2014
    * @description : create KM Feedback item record and test save() , articleQueryMethod() , cancel() methods for various scenarios.
    * @param 
    * @return void
    */  
    static testMethod void KMFeedbackAllMethodsTest() {
        
        init(); 
        Test.startTest();
        PageReference page = new PageReference(pageURL);
        Test.setCurrentPage(page);
        
        ApexPages.StandardController con = new ApexPages.StandardController(km_record);
        km_ext = new VFC18_KM_Feedback(con);
        
        km_record.Feedback__c = 'Test Feedback';
        km_ext.km_Feedback.Feedback_Reason__c = 'Negative Feedback ';
        km_ext.km_Feedback.Type_of_feedback__c='Negative';   
        
        km_ext.Save();
        //Assert to check save 
        
        system.assert(km_record.Feedback__c == 'Test Feedback');
        
        km_ext.articleQueryMethod();
        km_ext.cancel();
        
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 11/08/2014
    * @description : This test method is written to cover catch Exception in Save and articleQueryMethod methods
    * @param 
    * @return void
    */ 
    static testMethod void CatchExceptionFromSave_articleQueryMethodTest() {
        
        init();
        Test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(km_record);
        km_ext = new VFC18_KM_Feedback(null);
        
        try{
            km_ext.Save();
            km_ext.articleQueryMethod();
        }catch(exception ex)
        { 
            system.assert(ex.getMessage() != null);
        }
        
        Test.stopTest();
    }

    /**
    * @author IDC Team
    * @date 25/08/2014
    * @description : This test method is written to cover the code which cheks if functional area and sub-function is not blank 
    * @param 
    * @return void
    */
    static testMethod void KMFeedback_CheckFunctionSubFunctionTest() {
        
        init();
        Test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(km_record);
        km_ext = new VFC18_KM_Feedback(con);
       
        PageReference pageRef = Page.VFP18_KM_Feedback; 
        Test.setCurrentPage(pageRef);  
        
        km_ext.articleQueryMethod();
        km_ext.km_Feedback.Article_Title__c = 'Test FAQ';
        km_ext.km_Feedback.Functional_Area__c = 'Finance';
        km_ext.km_Feedback.Sub_Function__c = 'General Inquiry';          
        km_record.Feedback__c = 'Test Feedback';   
        km_ext.km_Feedback.Feedback_Reason__c = 'Content';
        km_ext.km_Feedback.Type_of_feedback__c='Content';
        km_ext.save();
        
        KMFeedback__c kmcustomsetting = [select id,Functional_Area__c,Sub_Function__c from KMFeedback__c limit 1];
        
        //Assert to check functional area and sub-function is not blank and matches a record in custom setting
        System.assert (km_ext.km_Feedback.Functional_Area__c == kmcustomsetting.Functional_Area__c);
        System.assert (km_ext.km_Feedback.Sub_Function__c == kmcustomsetting.Sub_Function__c);
            
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 25/08/2014
    * @description :This test method is written to check if function area is not blank and sub-function is blank
    * @param 
    * @return void
    */
    static testMethod void CheckNonBlankFunction_BlankSubFunctionTest() {
        
        init();
        List<KMFeedback__c> KMFeedback = KMFeedback__c.getall().values();
        for(KMFeedback__c objKMFD : KMFeedback){
            objKMFD.Sub_Function__c = '';
            objKMFD.KM_Champion_Username__c ='Testkmtest@sutterhealth.org'; 
        }
        update KMFeedback;
        
        Test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(km_record);
        km_ext = new VFC18_KM_Feedback(con);
       
        PageReference page = new PageReference(pageURL);
        Test.setCurrentPage(page);
        
        km_ext.articleQueryMethod();
        km_ext.km_Feedback.Article_Title__c = 'Test FAQ';
        km_ext.km_Feedback.Functional_Area__c = 'Finance';
        km_ext.km_Feedback.Sub_Function__c = '';
        km_record.Feedback__c = 'Test Feedback';  
        km_ext.km_Feedback.Feedback_Reason__c = 'Multiple Issues';
        km_ext.km_Feedback.Type_of_feedback__c='Multiple Issues';       

        km_ext.save();
        
        //Assert to check function area is not blank and sub-function is blank
        System.assert (km_ext.km_Feedback.Functional_Area__c != null);
        System.assert (km_ext.km_Feedback.Sub_Function__c == '');
            
        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 25/08/2014
    * @description : This test method is written to check feedback has some blacklisted words or not in preparePatterns method
    * @param 
    * @return void
    */
    static testMethod void KMFeedback_BlaclistedWordTest() {
        
        init();
        Blacklisted_Word__c obj = new Blacklisted_Word__c(Word__c='facebook',Substitution__c='********',is_Active__c=true,RegexValue__c='([f|F][a|A][c|C][e|E][b|B][o|O][o|O][k|K])',Match_Whole_Words_Only__c=true,Prevent_Post_on_Breach__c=true, Add_to_Compliance_Audit__c =true );
        insert obj ;  

        Blacklist_Audit__c obj1 = new Blacklist_Audit__c(Blacklisted_Word__c='[a-zA-Z][^a-zA-Z0-9][^a-zA-Z0-9]',Unscrubbed_Post__c='A**h**e'             );
        insert obj1 ; 
       
        Test.startTest();
              
        try{
            km_ext = new VFC18_KM_Feedback();

            PageReference page = new PageReference(pageURL);
            Test.setCurrentPage(page);
            km_ext.getArticleOptions();
            
            List<KM_Feedback_Item__c> kmFeedbackitem = new List<KM_Feedback_Item__c>();
            KM_Feedback_Item__c km1 = new KM_Feedback_Item__c(Status__c = 'New',Due_Date__c = date.today(),Feedback__c='facebook',Feedback_Reason__c = 'Positive Feedback',Type_of_feedback__c='Positive');
            kmFeedbackitem.add(km1);
            insert kmFeedbackitem;
            
            //Assert to check if Km feedback has blacklisted word 
            System.assert(kmFeedbackitem[0].Feedback__c==obj.Word__c );

            km_ext.filterKMFeedbackItems(kmFeedbackitem);
            km_ext.getArticleOptions(); 
            
        }catch(Exception ex){}   

        Test.stopTest();
    }
    
    /**
    * @author IDC Team
    * @date 26/Oct/2015
    * @description : This test method is written to check trigger and open Tasks when KM feedback is Closed - Completed 
    * @param  N/A
    * @return void
    */
    
    static testMethod void KmFeedback_Trigger_FeedbackClosedTest() {
        
        init();
        Test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(km_record);
        km_ext = new VFC18_KM_Feedback(con);
        PageReference pageRef = Page.VFP18_KM_Feedback; 
        Test.setCurrentPage(pageRef); 
        try {   
            km_ext.km_Feedback.Article_Title__c = 'Test FAQ';
            km_ext.km_Feedback.Functional_Area__c = 'Finance';
            km_ext.km_Feedback.Sub_Function__c = 'General Inquiry';          
            km_record.Feedback__c = 'Test Feedback';         
            km_ext.km_Feedback.Status__c ='Closed - Completed';
            km_ext.km_Feedback.Feedback_Reason__c = 'Access Issue';
            km_ext.km_Feedback.Type_of_feedback__c='Access Issue';
            insert km_ext.km_Feedback;
            km_ext.save();
            
            // create a task 
            Task testtask = new Task(
            ActivityDate = Date.today().addDays(7),
            Subject='Sample Task',
            WhatId = km_ext.km_Feedback.Id,
            Projected_Hours__c = 5 ,
            Status='In Progress');
            insert testtask; 
            
            // update Km feedback item record 
            km_ext.km_Feedback.Feedback_Reason__c = 'Positive Feedback';
            km_ext.km_Feedback.Type_of_feedback__c='Positive';
            update  km_ext.km_Feedback;
            km_ext.save();
            
            task openTasks = [select Id,Status, WhatId, isClosed From Task Where WhatId =:km_ext.km_Feedback.Id];
            
            //Assert to check task is not closed 
            system.assert(openTasks.isClosed != True);
    
        }catch (exception ex){}            
            
        Test.stopTest();
    }
}