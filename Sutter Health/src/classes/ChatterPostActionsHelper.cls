/**    
 *     Class Name  : ChatterPostActionsHelper
 *     Author      : IDC Offshore  
 *     Date        : 20-Oct-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : ChatterPostActionsHelper is helper class for Trigger to insert Suggestion Links to users in chatter.                      
 **/
public class ChatterPostActionsHelper {
    
    public static String SUGGESTLINKS = 'Suggested Links ';
    public static String WHEREKEY = 'Where';
    public static String HOWKEY = 'How';
    public static String FINDKEY = 'Find';
    public static String CREATEKEY = 'Create';
    public static String GRIDKEY = 'Grid';
    public static String BENEFITFORMAT = 'to Benefit Grid ';
    public static String BENEFITKEY = 'Benefit';
    public static String CONTACTKEY = 'Contact';
    public static String ACCOUNTKEY = 'Account';
    public static String MEMBERFORMAT = 'to Members ';
    public static String EMPLOYERFORMAT = 'to Employers ';
    public static String BROKERFORMAT = 'to Brokers ';
    public static String PROVIDERLINKFORMAT = 'to Providers ';
    public static String REPORTKEY = 'Report';
    public static String EMPLOYERACNTFORMANT = 'to Employer Account ';
    public static String BROKERACNTFORMAT = 'to Broker Account ';
    public static String SUBSCRIBERKEY = 'Subscriber';
    public static String SUBSCRIBERACNTFORMAT = 'to Subscriber Account ';
    public static String MEMBERACNTFORMAT = 'to Member Account ';
    public static String GRIEVANCELINKFORMAT =' Grievance Report Links ';
    public static String ILKEY = 'Il';
    public static String ILLINKFORMAT = 'Shp IL Report Links ';
    public static String SRKEY = 'SR';
    public static String SRLINKFORMAT = 'Shp SR Report Links ';
    public static String MEDKEY = 'Med';
    public static String MANAGEMENTKEY = 'Management';
    public static String MEDMANAGEMENTLINKFORMAT = 'Med Management Report Links ' ;
    public static String SCNLINKFORMAT = 'SCN Report Links ';
    public static String SURVEYKEY = 'Survey';
    public static String SURVEYLINKFORMAT = 'SHP Survey Report Links ';
    public static String MEMBERREPORTLINKFORMAT = 'SHP Member Report Links ';
    public static String BROKERREPORTLINKFORMAT = 'SHP Broker Report Links ';
    public static String PROVIDERREPORTLINKFORMAT = 'SHP Provider Report Links ';
    public static String EMPLOYERREPORTLINKFORMAT = 'SHP Employer Report Links ';
    public static String CORRESPONDENCEREPORTLINKFORMAT = 'SHP Correspondence Report Links ';
    public static String APPEALREPORTFORMAT = 'Appeal Report Links ';
    public static String PQITRAININGDOCFORMAT = 'PQI Training Doc Link ';
    public static String SCNTRAININGDOCFORMAT = 'SCN Training Doc Link ';
    public static String TEMPLATEKEY = 'Template';
    public static String CORRESPONDENCEDOCFORMAT = 'Correspondence Template Training Doc Link ';
    private static final string EXEPTION_MSG1 = '--------------';
    private static final string EXEPTION_MSG = '\r\n';
  
    
    
    /**
    *   @Description: Methods creates Comment for Chatter Posts containing suggested Links.
    *   @Arguments: FeedItem ParentPost, String LinkUrlToPost     
    *   @Return: FeedComment 
    **/
    public FeedComment createSuggestionLinkComment( FeedItem ParentPost , String LinkUrlToPost ) {
        FeedComment RelatedFeed = new FeedComment( CommentBody = SUGGESTLINKS+LinkUrlToPost,
                                                   FeedItemId = ParentPost.Id,
                                                   CreatedById = System.Label.Chatter_Expert_User_Id );
        return RelatedFeed;
    }
    
    /**
    *   @Description: Methods creates Autosuggest Comments for Chatter Posts containing Benefit Grid Keywords.
    *   @Arguments: FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert  
    *   @Return: void 
    **/
    public void getLinkForBenefitGridtab( FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert ) {
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(BENEFITKEY) && SharedPost.Body.containsIgnoreCase(GRIDKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.BENEFITGRID);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, BENEFITFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
    }
    
    /**
    *   @Description: Methods creates Autosuggest Comments for Chatter Posts containing Contact Keywords.
    *   @Arguments: FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert  
    *   @Return: void 
    **/
    public void getLinkForContactTabs( FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert ) {
        
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.MEMBERREPORT) && SharedPost.Body.containsIgnoreCase(CONTACTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.MEMBERCONKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, MEMBERFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.EMPLOYEREPORT) && SharedPost.Body.containsIgnoreCase(CONTACTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.EMPLOYERCONKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, EMPLOYERFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.BROKERREPORT) && SharedPost.Body.containsIgnoreCase(CONTACTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.BROKERCONKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, BROKERFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.PROVIDEREPORT) && SharedPost.Body.containsIgnoreCase(CONTACTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.PROVIDERCONKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, PROVIDERLINKFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
    }
    
    /**
    *   @Description: Methods creates Autosuggest Comments for Chatter Posts containing Account Keywords.
    *   @Arguments: FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert  
    *   @Return: void 
    **/
    public void getLinksForAccountTabs( FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert ) {
        
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.EMPLOYEREPORT) && SharedPost.Body.containsIgnoreCase(ACCOUNTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.EMPLOYERACNTKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, EMPLOYERACNTFORMANT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
            
        if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.BROKERREPORT) && SharedPost.Body.containsIgnoreCase(ACCOUNTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.BROKERACNTKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, BROKERACNTFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
            
       if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(SUBSCRIBERKEY) && SharedPost.Body.containsIgnoreCase(ACCOUNTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.SUBSCRIBERACNTKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, SUBSCRIBERACNTFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
       }
      /*     
       if( SharedPost.Body.containsIgnoreCase(WHEREKEY) && SharedPost.Body.containsIgnoreCase(FINDKEY)&&
            SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.MEMBERREPORT) && SharedPost.Body.containsIgnoreCase(ACCOUNTKEY)) {
                    
            String SuggestedLink = ManageChatterPostActions.getTabLinkForDetectedKeyword(ManageChatterPostActions.MEMBERACNTKEY);
            FeedComment SuggestedComment;
                    
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, MEMBERACNTFORMAT+SuggestedLink );
            }
                    
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }*/
    }
    
    /**
    *   @Description: Methods creates Autosuggest Comments for Chatter Posts containing Report Related Keywords.
    *   @Arguments: FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert  
    *   @Return: void 
    **/
    public void getLinksForReportKeywords( FeedItem SharedPost , List < FeedComment > FeedCommentsToInsert ) {
        
        if( SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.GRIEVANCEKEY) && SharedPost.Body.containsIgnoreCase(REPORTKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.GRIEVANCEKEY);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost,GRIEVANCELINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ILKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.SHPIL);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost,ILLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(SRKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.SHPSR);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, SRLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(MEDKEY) && SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(MANAGEMENTKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.MEDMANAGEMENT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, MEDMANAGEMENTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if((SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.SCNKEY) || SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.SCNREPORT)) && SharedPost.Body.containsIgnoreCase(REPORTKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.SCNREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, SCNLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(SURVEYKEY)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.SHPSURVEY);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost,SURVEYLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.MEMBERREPORT)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.MEMBERREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost,MEMBERREPORTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.BROKERREPORT)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.BROKERREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, BROKERREPORTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.PROVIDEREPORT)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.PROVIDEREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, PROVIDERREPORTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.EMPLOYEREPORT)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.EMPLOYEREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, EMPLOYERREPORTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.CORRESPONDREPORT)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.CORRESPONDREPORT);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost,CORRESPONDENCEREPORTLINKFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(REPORTKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.APPEALKEYWORD)) {
            String SuggestedLink = ManageChatterPostActions.getReportLinksForRespectiveKeyWords(ManageChatterPostActions.APPEALKEYWORD);
            FeedComment SuggestedComment;
                
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, APPEALREPORTFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
    }
    
    /**
    *   @Description: Methods creates Autosuggest Comments for Chatter Posts containing Training Document Related Keywords.
    *   @Arguments: FeedItem SharedPost, List < FeedComment > FeedCommentsToInsert  
    *   @Return: void 
    **/
    public void getLinksForTrainingDocument( FeedItem SharedPost , List < FeedComment > FeedCommentsToInsert ) {
        
        if( SharedPost.Body.containsIgnoreCase(HOWKEY) && SharedPost.Body.containsIgnoreCase(CREATEKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.PQIKEY)) {
            String SuggestedLink = ManageChatterPostActions.getTrainingDocumentLinkForRespectiveKeyword(ManageChatterPostActions.PQIKEY);
            FeedComment SuggestedComment;
            
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, PQITRAININGDOCFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(HOWKEY) && SharedPost.Body.containsIgnoreCase(CREATEKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.SCNKEY)) {
            String SuggestedLink = ManageChatterPostActions.getTrainingDocumentLinkForRespectiveKeyword(ManageChatterPostActions.SCNKEY);
            FeedComment SuggestedComment;
            
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, SCNTRAININGDOCFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
        
        if( SharedPost.Body.containsIgnoreCase(HOWKEY) && SharedPost.Body.containsIgnoreCase(CREATEKEY) && SharedPost.Body.containsIgnoreCase(ManageChatterPostActions.CORRESPONDREPORT) &&
            SharedPost.Body.containsIgnoreCase(TEMPLATEKEY)) {
            String SuggestedLink = ManageChatterPostActions.getTrainingDocumentLinkForRespectiveKeyword(ManageChatterPostActions.CORRESPONDECETEMPLATE);
            FeedComment SuggestedComment;
            
            if( !String.isEmpty( SuggestedLink )) {
                SuggestedComment = createSuggestionLinkComment( SharedPost, CORRESPONDENCEDOCFORMAT+SuggestedLink);
            }
                
            if( SuggestedComment != null ) {
                FeedCommentsToInsert.add(SuggestedComment);
            }
        }
    }
    
    /**
    *   @Description: Methods creates Comment for Chatter Posts containing suggested Links.
    *   @Arguments: FeedItem List ParentPost    
    *   @Return: void 
    **/
    public void suggestLinksThroughChatterComments(List<FeedItem> InsertedFeedItemList ){
    
        List  < FeedComment > FeedCommentsToInsert = new List < FeedComment > ();
      
        try {
            for( FeedItem SharedPost: InsertedFeedItemList ) {
                getLinkForBenefitGridtab( SharedPost , FeedCommentsToInsert );
                getLinkForContactTabs( SharedPost ,FeedCommentsToInsert );
                getLinksForAccountTabs( SharedPost ,FeedCommentsToInsert );
                getLinksForReportKeywords( SharedPost ,FeedCommentsToInsert);
                getLinksForTrainingDocument( SharedPost , FeedCommentsToInsert);
            }
            
            if( !FeedCommentsToInsert.isEmpty()) {
                Database.insert( FeedCommentsToInsert );
            }
        }catch( Exception CodeEx ) {
            Utility.handleExceptionFromCode(CodeEx.getMessage() + EXEPTION_MSG + CodeEx.getStackTraceString() + EXEPTION_MSG  + CodeEx.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG  + EXEPTION_MSG1 );
        }
    } 
}