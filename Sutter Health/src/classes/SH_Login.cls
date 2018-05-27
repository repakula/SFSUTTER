/**
   @Author      : Alok Verma
   @name        : SH_Login
   @CreateDate  : 20/07/2015 (DD/MM/YYYY)
   @Description : Controller for SH_Login Page
   @Version     : 1.0
   @reference   : SiteLoginController
*/
global class SH_Login {
    global String username {get; set;}
    global String password {get; set;}

     /**
    * @author       :   Alok Verma
    * @date         :   20/07/2015
    * @description  :   Implements Authentication Logic 
    * @param        :   N/A
    * @return       :   N/A
    */   
    global PageReference login() 
    {      
        string requestedURL = ApexPages.currentPage().getParameters().get('startURL');
        string startURL = '/SH_Landing';
        
        if(!string.IsBlank(requestedURL) && !requestedURL.contains('.jsp')) {
            startURL = requestedURL;
        }
        
        return Site.login(username, password, startURL);
    }
}