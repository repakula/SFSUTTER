/*
    This class is used to show history data on page
    ===================================================================
    Name                    Date                       version
    ===================================================================
    Prashant Kumar        7/20/2015                        1.0
    ===================================================================
*/
public class SH_History extends SH_BaseController {
    //class level variables
    public list<ArticleHistory> lstArticleHistory {get; set;}
    public boolean IsSearchResultFound {get; set;}
    
    /*
        constructor method
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/20/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        ================================================================  
    */
    public SH_History() {
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing'), new SH_BreadCrumb('History' , '#')};
        activePgName = 'History';
        lstArticleHistory = new list<ArticleHistory>();
        BindData();
    }   
    
    /*
        This method is used to bind data on page
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/20/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        ================================================================  
    */
    private void BindData() {
        set<ID> setArticleId = new set<ID>();
        for(SH_History__c oHistory : [select id , SH_Article_Id__c, SH_Record_Count__c, SH_Summary__c, SH_Title__c, SH_User__c, Sh_View_Date__c 
                        from SH_History__c where SH_User__c =: objUser.Id order by LastModifiedDate desc limit 999]) {
            if(string.isNotBlank(oHistory.SH_Article_Id__c)) {
                lstArticleHistory.add(new ArticleHistory(oHistory));
                setArticleId.add(oHistory.SH_Article_Id__c);
            }
        }
        
        map<ID,Decimal> mapArticleIdToScore = SH_Common.GetArticleRatings(setArticleId);
        
        if(lstArticleHistory.size()>0) {
            for(ArticleHistory oArticleHistory : lstArticleHistory) {
                Decimal decRating = mapArticleIdToScore.get(oArticleHistory.history.SH_Article_Id__c);
                oArticleHistory.rating = decRating == null? 0: decRating;
            }
        }
                        
        IsSearchResultFound = lstArticleHistory.size() > 0 ? true : false;
    }
    
    
    /*
        This is wrapper class for article history
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/20/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        ================================================================  
    */
    public class ArticleHistory {
        public SH_History__c history {get;set;}
        public decimal rating {get; set;}
        
        public ArticleHistory(SH_History__c oHistory) {
            this.history = oHistory;
        }
    }
}