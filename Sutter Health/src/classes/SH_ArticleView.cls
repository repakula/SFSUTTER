/*
	This class used to show the Article on Community / portal screen
	================================================================
	Name 					   Date 					  version
	================================================================
	Alok Verma				  9/25/2015						1.0
	================================================================	
*/
public with sharing class SH_ArticleView  extends SH_BaseController {
    //class members
    public string strKnowledgeArticleId {get;set;}
    string strArticleSummary, strArtilceTitle;
    public list<wrapArticleData> lstSuggestedArticles {get; set;}
    public boolean showSuggestedArticlePnl {get; set;}
    public string showPnl {get;set;}
    
    //constructor
    public SH_ArticleView() {
        Initialize();
    }
    
    /*
		This Method is used to initialize the variables
		================================================================
		Name 					   Date 					  version
		================================================================
		Alok Verma				  9/25/2015						1.0
		================================================================
		Input Param: None
		================================================================
		Output : None
		================================================================	
	*/
    private void Initialize() {
        string strArticleId = ApexPages.currentPage().getParameters().get('id');
        showPnl = '';
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'Article';
        setBreadCrumbs(); 
        
        BreadCrumbs.add(new SH_BreadCrumb('Article' , '#'));
        
        
        lstSuggestedArticles = new list<wrapArticleData>();
        showSuggestedArticlePnl = false;
        GetData(strArticleId);
    }
    
    /*
		This method is used to get data based on article id
		================================================================
		Name 					   Date 					  version
		================================================================
		Alok Verma				  9/25/2015						1.0
		================================================================
		Param : String
		================================================================
		Output : None
		================================================================	
	*/
    private void GetData(string strArticleId) {
        if(!string.isBlank(strArticleId)) {
            KnowledgeArticleVersion oKnowledgeArticleVersion = SH_Common.FetchPublishedArticleData(strArticleId);
            if(oKnowledgeArticleVersion != null) {
                strArtilceTitle = oKnowledgeArticleVersion.Title;
                strArticleSummary = oKnowledgeArticleVersion.summary;
                strKnowledgeArticleId = oKnowledgeArticleVersion.KnowledgeArticleId;
                if(!string.IsBlank(strArtilceTitle)) {
                    integer maxSuggestedArticlesToShow = 5;
                    for(SH_ResultItems resultItems : SH_SearchArticles.SearchArticles_Advance(strArtilceTitle + '*', false, null)) {
                        if(resultItems.Id != strKnowledgeArticleId && resultItems.Type != SH_SearchResultType.TOOL) {
                            if(maxSuggestedArticlesToShow == 0)
                                break;
                            lstSuggestedArticles.add(new wrapArticleData(resultItems.Header, resultItems.Id));
                            showPnl = 'showSuggestedArticlePnl';
                            
                            maxSuggestedArticlesToShow --;
                        }
                    }
                }
            }
            else {showPnl = 'showWarningMsgPnl';}
        }
    } 
    
    /*
		This method is used to create history record
		================================================================
		Name 					   Date 					  version
		================================================================
		Alok Verma				  9/25/2015						1.0
		================================================================
		Param : none
		================================================================
		Output : none
		================================================================	
	*/
    public void CreateHistoryRecord() {
        if(objUser != null && !string.isBlank(strKnowledgeArticleId)) {
            //check if history record already exist
            list<SH_History__c> lstHistory = [select Id,SH_Title__c,SH_Summary__c,Sh_View_Date__c,SH_User__c,SH_Record_Count__c from SH_History__c where SH_User__c =: objUser.Id and SH_Article_Id__c =: strKnowledgeArticleId];
            
            if(lstHistory.size() == 0) {
                SH_History__c objHistory = new SH_History__c(SH_Article_Id__c=strKnowledgeArticleId, Sh_View_Date__c= system.today(),SH_User__c =objUser.Id, SH_Record_Count__c = 1);
                objHistory.SH_Title__c = strArtilceTitle;
                objHistory.SH_Summary__c = strArticleSummary;       
                insert objHistory;
            }
            else {
                SH_History__c objHistory = lstHistory[0];
                objHistory.SH_Record_Count__c = objHistory.SH_Record_Count__c != null ? objHistory.SH_Record_Count__c + 1 : 1;
                objHistory.Sh_View_Date__c = system.today();
                objHistory.SH_Title__c = strArtilceTitle;
                objHistory.SH_Summary__c = strArticleSummary;   
                
                update objHistory; 
            }
        }
    }
    
    /*
		This class is used to wrap the article data
		================================================================
		Name 					   Date 					  version
		================================================================
		Alok Verma				  9/25/2015						1.0
		================================================================
		Param : none
		================================================================
		Output : none
		=================================================================	
	*/
    public class wrapArticleData {
        public string strTitle {get;set;}
        public string strArticleId {get; set;}
        
        public wrapArticleData(string title, string articleId) {
            this.strTitle = title;
            this.strArticleId = articleId;
        }
    }
}