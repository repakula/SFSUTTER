/**    
 *     Class Name  : ChatterPostActionsHelper_Test
 *     Author      : IDC Offshore  
 *     Date        : 01-Sep-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : Test Class for ChatterPostActionsHelper Trigger helper Class.
 **/
@isTest
private class ChatterPostActionsHelper_Test {
    /**
    *   @Description: Methods creates test user for Inserting Post in Chatter.
    *   @Arguments: None     
    *   @Return: User
    **/
    static User getUser(){ 
      String aliasString = 'ChatT';
      Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
      User usr = new User(
      alias = aliasString, 
      email= aliasString+'@accenture.com',
      emailencodingkey='UTF-8',
      lastname='Testing', 
      languagelocalekey='en_US',
      localesidkey='en_US',
      profileid = sysAdminId,
      timezonesidkey='Europe/London',
      username= aliasString+'@accenture.com');
      return usr;
    }

    /**
    *   @Description: Methods creates Posts containing Contact keywords and check for the Suggested auto generated 
    *                 commnent by system.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void ContactTabLinksPostTest() {
        User testUser = getUser();
        insert testUser;
        List<FeedItem> ChatterPostsListTobeInserted = new List<FeedItem>();
        
        FeedItem chatterPost1 = new FeedItem(Body = 'where to find member contact ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost1);
        
        FeedItem chatterPost2 = new FeedItem(Body = 'where to find employer contact ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost2);
        
        FeedItem chatterPost3 = new FeedItem(Body = 'where to find Broker contact ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost3);
        
        FeedItem chatterPost4 = new FeedItem(Body = 'where to find provider contact ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost4);
        
        FeedItem chatterPost5 = new FeedItem(Body = 'where to find Benefits Grid ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost5);
        
        Test.startTest();
        Database.insert(ChatterPostsListTobeInserted);
        Test.stopTest();
        
        List< FeedComment > SuggestedCommentLinks = [ Select Id, CommentBody FROM FeedComment ];
        
        if( !SuggestedCommentLinks.isEmpty() ) {
            system.assertEquals( SuggestedCommentLinks.size(),5 );
            
            for( FeedComment suggestedComment:SuggestedCommentLinks) {
                system.assertNotEquals( suggestedComment.CommentBody , null );
            }
        }
        
    }
    
    /**
    *   @Description: Methods creates Posts containing Account keywords and check for the Suggested auto generated 
    *                 commnent by system.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void AccountTabLinksPostTest() {
        User testUser = getUser();
        insert testUser;
        List<FeedItem> ChatterPostsListTobeInserted = new List<FeedItem>();
        /*
        FeedItem chatterPost1 = new FeedItem(Body = 'where to find member account ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost1);*/
        
        FeedItem chatterPost2 = new FeedItem(Body = 'where to find employer account ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost2);
        
        FeedItem chatterPost3 = new FeedItem(Body = 'where to find Broker account ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost3);
        
        FeedItem chatterPost4 = new FeedItem(Body = 'where to find subscriber account ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost4);
        
        Test.startTest();
        Database.insert(ChatterPostsListTobeInserted);
        Test.stopTest();
        
        List< FeedComment > SuggestedCommentLinks = [ Select Id, CommentBody FROM FeedComment ];
        
        if( !SuggestedCommentLinks.isEmpty() ) {
            system.assertEquals( SuggestedCommentLinks.size(),3 );
            
            for( FeedComment suggestedComment:SuggestedCommentLinks) {
                system.assertNotEquals( suggestedComment.CommentBody , null );
            }
        }
    }
    
    /**
    *   @Description: Methods creates Posts containing Training Document keywords and check for the Suggested auto generated 
    *                 commnent by system.
    *   @Arguments: None     
    *   @Return: void
    **/
    static testMethod void TrainingDocTabLinksPostTest() {
        User testUser = getUser();
        insert testUser;
        List < SHP_Training_Document__kav > TrainingDocListToInsert = new List < SHP_Training_Document__kav >();
        
        SHP_Training_Document__kav PQIDoc = new  SHP_Training_Document__kav( Title ='PQI Training Document',
                                                                             UrlName ='PQI-Training');
        TrainingDocListToInsert.add( PQIDoc);
        
        SHP_Training_Document__kav SCNDoc = new  SHP_Training_Document__kav( Title ='SCN Training Document',
                                                                             UrlName ='SCN-Training');
        TrainingDocListToInsert.add(SCNDoc);
        
        SHP_Training_Document__kav CorrepondenceDoc = new  SHP_Training_Document__kav( Title ='Broker Correspondence Training Doc ',
                                                                             UrlName ='Correspondence-Training');
        TrainingDocListToInsert.add( CorrepondenceDoc);
        
        Database.insert( TrainingDocListToInsert );
        
        if( !TrainingDocListToInsert.isEmpty() ) {
            for( SHP_Training_Document__kav trainingDoc : [Select Id, KnowledgeArticleId FROM SHP_Training_Document__kav WHERE PublishStatus='Draft' AND Language = 'en_US'] ) {
                KbManagement.PublishingService.publishArticle( trainingDoc.KnowledgeArticleId  ,false);
            }
        }
        
        List<FeedItem> ChatterPostsListTobeInserted = new List<FeedItem>();
        
        FeedItem chatterPost1 = new FeedItem(Body = 'How to create PQI ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost1);
        
        FeedItem chatterPost2 = new FeedItem(Body = 'How to create SCN?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost2);
        
        FeedItem chatterPost3 = new FeedItem(Body = 'How to create Correspondence template ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost3);
        
        Test.startTest();
        Database.insert(ChatterPostsListTobeInserted);
        Test.stopTest();
        
        List< FeedComment > SuggestedCommentLinks = [ Select Id, CommentBody FROM FeedComment ];
        
        if( !SuggestedCommentLinks.isEmpty() ) {
            system.assertEquals( SuggestedCommentLinks.size(),3 );
            
            for( FeedComment suggestedComment:SuggestedCommentLinks) {
                system.assertNotEquals( suggestedComment.CommentBody , null );
            }
        }
    }
    
    /**
    *   @Description: Methods creates Posts containing Reports keywords and check for the Suggested auto generated 
    *                 commnent by system.
    *   @Arguments: None     
    *   @Return: void
    **/
    @isTest(SeeAllData=true)
    static void ReportLinksPostTest() {
        User testUser = getUser();
        insert testUser;
        List<FeedItem> ChatterPostsListTobeInserted = new List<FeedItem>();
        
        FeedItem chatterPost1 = new FeedItem(Body = 'where are Grievance Reports ?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost1);
        
        FeedItem chatterPost2 = new FeedItem(Body = 'where are member Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost2);
        
        FeedItem chatterPost3 = new FeedItem(Body = 'where are provider Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost3);
        
        FeedItem chatterPost4 = new FeedItem(Body = 'where are broker Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost4);
        
        FeedItem chatterPost6 = new FeedItem(Body = 'where are SR Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost6);
        
        FeedItem chatterPost7 = new FeedItem(Body = 'where are IL Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost7);
        
        FeedItem chatterPost8 = new FeedItem(Body = 'where are Medical Management Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost8);
        
        FeedItem chatterPost9 = new FeedItem(Body = 'where are SCN Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost9);
        
        FeedItem chatterPost10 = new FeedItem(Body = 'where are correspondence Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost10);
        
        FeedItem chatterPost11 = new FeedItem(Body = 'where are Emplyer Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost11);
        
        FeedItem chatterPost12 = new FeedItem(Body = 'where are survey Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost12);
        
        FeedItem chatterPost13 = new FeedItem(Body = 'where are appeal Reports?',
                                             ParentId = testUser.Id);
        ChatterPostsListTobeInserted.add(chatterPost13);
        
        
        Test.startTest();
        Database.insert(ChatterPostsListTobeInserted);
        Test.stopTest();
        
        List< FeedComment > SuggestedCommentLinks = [ Select Id, CommentBody FROM FeedComment ];
        
        if( !SuggestedCommentLinks.isEmpty() ) {
           // system.assertEquals( SuggestedCommentLinks.size(),28 );
            
            for( FeedComment suggestedComment:SuggestedCommentLinks) {
                system.assertNotEquals( suggestedComment.CommentBody , null );
            }
        }
    }   
}