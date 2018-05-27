/*
    This class is used to create the Coursel on page
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok Verma        7/15/2015                        1.0
    ==========================================================  
*/
public class SH_Landing extends SH_BaseController 
{
    //public members
    public list<ContentWrapper> lstHeadliner {get;set;}
    public list<ContentWrapper> lstCarousel {get;set;}
    public set<String> setToolId = new set<String>();
    //added on 05-Nov-2015 for setting home page slider animation homeSliderInterval
    public integer homeSliderInterval {get;set;}

    /*
        constructor
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/15/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        ===================================================================
    */
    public SH_Landing() {
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        Initialize();
        BindData();
    }
    
    /*
        This method is used to initialize the variables
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/15/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        =================================================================== 
    */    
    private void Initialize() {
        lstHeadliner = new list<ContentWrapper>();
        lstCarousel = new list<ContentWrapper>();
        //added on 05-Nov-2015 for setting home page slider animation 
        SH_Community_Settings__c objCommSetting = SH_Community_Settings__c.getValues('Setting-1');
        homeSliderInterval = (objCommSetting != null && objCommSetting.SH_Home_Page_Slider_Interval__c != null) ? integer.valueOf(objCommSetting.SH_Home_Page_Slider_Interval__c) : 8000;
    }
    
    
    /*
        This method is used Fetch Data needed to render on Page
        ===================================================================
        Name                    Date                       version
        ===================================================================
        Prashant Kumar        7/15/2015                        1.0
        ===================================================================
        Param: none
        ===================================================================
        Output :  none
        ===================================================================
    */
    private void BindData() 
    {
        list<SH_Home_Page_Headliner__c> LstSH_Home_Page_Headliner = isPreview ? [select id,SH_Headliner_description__c,SH_Title__c,SH_Content_Image_Url__c,
                                                SH_Article_Link__c,SH_Content_Type__c, SH_Content_Link__c,SH_Content_Target__c 
                                                from SH_Home_Page_Headliner__c where SH_Is_Preview__c = true order by SH_Order_of_display__c asc limit 5]
                                                : [select id,SH_Headliner_description__c,SH_Title__c,SH_Content_Image_Url__c,SH_Article_Link__c,
                                                SH_Content_Type__c,SH_Content_Link__c,SH_Content_Target__c  
                                                from SH_Home_Page_Headliner__c where SH_Is_Publish__c= true order by SH_Order_of_display__c asc limit 5];
        
        list<SH_HomePage_Carousel__c> LstSH_Home_Page_carousel = isPreview ? [select id,SH_Carousel_description__c,SH_Title__c,SH_Icon__c,SH_Article_Link__c,
                                                SH_Content_Type__c,SH_Content_Link__c,SH_Content_Target__c  
                                                from SH_HomePage_Carousel__c where SH_Is_Preview__c= true order by SH_Order_of_display__c asc limit 10]
                                             : [select id,SH_Carousel_description__c,SH_Title__c,SH_Icon__c,SH_Article_Link__c,
                                                SH_Content_Type__c,SH_Content_Link__c,SH_Content_Target__c 
                                               from SH_HomePage_Carousel__c where SH_Is_Publish__c= true order by SH_Order_of_display__c asc limit 10];
        
        if(LstSH_Home_Page_Headliner.size() > 0) {
            for(SH_Home_Page_Headliner__c objHeadliner : LstSH_Home_Page_Headliner) {
                if(string.isNotBlank(objHeadliner.SH_Content_Type__c) && objHeadliner.SH_Content_Type__c.equalsIgnoreCase('Tool') && string.isNotBlank(objHeadliner.SH_Article_Link__c))
                    setToolId.add(objHeadliner.SH_Article_Link__c);
            }
        }
        
        if(LstSH_Home_Page_carousel.size() > 0) {
            for(SH_HomePage_Carousel__c objCarousel : LstSH_Home_Page_carousel) {
                if( string.isNotBlank(objCarousel.SH_Content_Type__c) && objCarousel.SH_Content_Type__c.equalsIgnoreCase('Tool') && string.isNotBlank(objCarousel.SH_Article_Link__c))
                    setToolId.add(objCarousel.SH_Article_Link__c);    
            }
        }
        
        setToolsMap(setToolId);
        lstHeadliner = GetContentWrapper(LstSH_Home_Page_Headliner, false);
        lstCarousel = GetContentWrapper(LstSH_Home_Page_carousel, false);
    }
}