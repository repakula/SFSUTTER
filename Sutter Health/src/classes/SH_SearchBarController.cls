/*
    This class is used to get Published Articles/Tools
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
*/
public with sharing class SH_SearchBarController extends SH_BaseController{

    public Boolean isPreview { get; set; }
    public String SearchString {get;set;}
    public Boolean IsSearchResultFound {get; set;}
    private List<SH_ResultItems> InnerSearchResults {get; set;}
    public List<SH_ResultItems> SearchResults{get; set;}
    public Boolean IsShowError{get; set;}
    public List<SelectOption> ArticlesTypeNames {get; set;}
    public String SelectedView {get;set;}
    public SH_Common.SpellChecker spellCheck {get; set;}

    //constructor to initialize variables
    public SH_SearchBarController()
    {   
        ArticlesTypeNames = SH_Common.getKnowledgeArticleObjectsLabels();
        
        if(ArticlesTypeNames != null && ArticlesTypeNames.size() > 0)    
            ArticlesTypeNames.add(0, new SelectOption('All','All'));
            
        SelectedView = 'All';
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing'), new SH_BreadCrumb('Search' , '#')};
        activePgName = 'Search';
        spellCheck = new SH_Common.SpellChecker();
    }
    /*
    This Method is used to filter results
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: None
    ===========================================================
    Output : pagereference 
    ===========================================================
    */
    public pagereference ChangeView(){
        SearchResults = new List<SH_ResultItems>();
        if(string.isNotBlank(SelectedView) && SelectedView.equalsIgnoreCase('All')){
            SearchResults = InnerSearchResults;
        }else{
            for(SH_ResultItems item : InnerSearchResults){              
                if(item.ArticleType.equalsIgnoreCase(SelectedView)){
                    SearchResults.add(item);
                }
            }
        }
        return null;
    }
    /*
    This Method loads on page load and fetch the Article/Tools
    based on entered keyword
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: None
    ===========================================================
    Output : None 
    ===========================================================
    */
    public void DoPageLoadActon(){
        IsShowError = false;
        isPreview = ApexPages.currentPage().getParameters().get('cmd')==null ? false : true;
        SearchString = ApexPages.currentPage().getParameters().get('q')!=null && ApexPages.currentPage().getParameters().get('q')!='null' ? ApexPages.currentPage().getParameters().get('q') : '';
        if(SearchString!='' && SearchString.length()<3){
            IsShowError = true;
            return;
        }
        
        SearchResults = new List<SH_ResultItems>();
        if(string.isNotBlank(SearchString)){
            //added mapOfToolKav parametetr on 25-Aug-2015 for Notification
            //InnerSearchResults = SearchResults = SH_SearchArticles.SearchArticles_Advance(SearchString + '*', true, mapOfToolKav); 
            InnerSearchResults = SearchResults = SH_SearchArticles.SearchArticles_Advance(SearchString , true, mapOfToolKav); 
            
            if(SearchResults != null && SearchResults.size()>0)
                IsSearchResultFound = true;
            else{
                IsSearchResultFound = false;
                spellCheck = SH_Common.Spellcheck(SearchString);
            }
        }else{
            IsSearchResultFound = false;
        }
    }
}