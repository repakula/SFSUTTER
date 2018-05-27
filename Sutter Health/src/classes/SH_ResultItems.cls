global class SH_ResultItems{
    public String Id {get; set;}
    public String Header {get; set;}
    public String Description {get; set;}
    public SH_SearchResultType Type {get;set;}
    public Boolean IsPrioritize {get; set;} 
    public Date PriorityStartOn {get; set;}
    public Date PriorityEndOn {get; set;}
    public String Keywords {get; set;}
    public String ArticleType {get; set;}
    public Decimal ArticleRating {get; set;}
    
    //added on 18-Sep-2015 for sorting type
    public SH_SearchResultType SortingType {get; set;}
    
    //added on 25-Aug-2015 for Notification
    public string link {get; set;}
    
    //added on 14-Sep-2015 for ArticleNumber
    public string ArticleNumber{get; set;}
    
    public SH_ResultItems(String id, String header, String description, SH_SearchResultType type, Boolean isShowFullDescription){
        this.Id = id;
        this.Header = header;
        this.Description = (isShowFullDescription ? description : (description != null && description != '' && description.length() > 130 ? description.substring(0, 130) + '...' : description));
        this.Type = type;
        this.ArticleRating = 0.00;
        //added on 25-Aug-2015 for Notification
        this.link = '';
    }
       
    public SH_ResultItems(){
        this.ArticleRating = 0.00;
        //added on 25-Aug-2015 for Notification
        this.link = '';
    }
    
    public string getEnumName(){
        return this.Type.name();
    }
}