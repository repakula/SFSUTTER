/*
    This Enum is used to categorize the global searchResult
    ================================================
    Name                Date                version
    ================================================
    Rishabh Pilani      7/31/2015           1.0
    ================================================         
*/
global enum SH_SearchResultType{
    TOOL,
    ARTICLE,
    DATED_ARTICLE,
    FLAGGED_ARTICLE,
    FLAGGED_KEYWORD_ARTICLE, //added on 26-Aug-2015 for Flagged Keyword
    FLAG_KEY_JumbledExactMatchARTICLE_SC,
    FLAG_KEY_JumbledPartialMatchARTICLE_SC,
    FLAG_KEY_JumbledExactMatchARTICLE,
    FLAG_KEY_JumbledPartialMatchARTICLE,
    
    //added on 18-Sep-2015
    ArticleNumberExactMatch,
    TitleExactMatch,
    TitleStartsWith,
    TitleContains,
    TitleJumbledExactMatch_SC,
    TitleStartWithKeyFirstPart_SC,    
    TitleJumbledPartialMatch_SC,
    
    TitleJumbledExactMatch,
    TitleStartWithKeyFirstPart,    
    TitleJumbledPartialMatch,
    
    ToolArticleNumberExactMatch,
    ToolTitleExactMatch,
    ToolTitleStartsWith,
    ToolTitleContains,
    ToolTitleJumbledExactMatch_SC,
    ToolTitleStartWithKeyFirstPart_SC,    
    ToolTitleJumbledPartialMatch_SC,
    ToolTitleJumbledExactMatch,
    ToolTitleStartWithKeyFirstPart,
    ToolTitleJumbledPartialMatch,
    //added on 19-02-2016 to fetch Articles and Tools with Exact Phrase Match
    ArticleExactPhrase,
    ToolExactPhrase
}