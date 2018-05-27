/*
This class is used to get Published Articles/Tools
in Global search
==========================================================
Name                    Date                       version
==========================================================
Rishabh Pilani          7/31/2015                   1.0
==========================================================  
*/
global with sharing class SH_SearchBarRemoteController{    
    
    public String SearchString {get;set;}
    
    /************Remote Action************/
    /*
    This Method is used to get Published Articles/Tools
    based on the entered keyword
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
    Input Param: String searchItem
    ===========================================================
    Output : List<SH_ResultItems>  
    ===========================================================
    */
    @RemoteAction
    global static List<SH_ResultItems> getSearchResult(String searchItem) {
        //return SH_SearchArticles.SearchArticles_Advance(searchItem + '*', false);
        //added on 17-Sep-2015 to limit the search result to 5
        list<SH_ResultItems> searchResults = new list<SH_ResultItems>();
        integer maxArticlesToolToShow = 5;
        for(SH_ResultItems resultItems : SH_SearchArticles.SearchArticles_Advance(searchItem , false)) {
            if(maxArticlesToolToShow == 0)
                break;
            searchResults.add(resultItems);
            
            maxArticlesToolToShow --;
        }
        return searchResults;
    }  
    /*
    This Method is used to Redirect on SearchResultPage 
    with entered keyword
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
    public pagereference RedirectToSearchResultPage(){
        //pagereference pr = new pagereference('/apex/sh_searchresult?q=' + SearchString);
        pagereference pr = new pagereference('/apex/sh_searchresult');
        pr.getParameters().put('q', SH_Common.getUrlEncodedValue(SearchString));
        return pr.setRedirect(true);
    }    
    
}