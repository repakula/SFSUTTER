/**
   @Author      : Shakti Mehtani
   @name        : ProviderLoginController
   @CreateDate  : 12/11/2014 (DD/MM/YYYY)
   @Description : Controller for ProviderLogin Page
   @Version     : 1.0
   @reference   : SiteLoginController
*/
global class ProviderLoginController {
	global String username {get; set;}
    global String password {get; set;}

    global ProviderLoginController () {}
    
     /**
    * @author       :   Shakti Mehtani
    * @date         :   12/11/2014
    * @description  :   Implements Provider's Authentication Logic 
    * @param        :   N/A
    * @return       :   N/A
    */   
    global PageReference login() { 
    	String startURL = '/ValidateProvider';
		return Site.login(username, password, startURL);
    }
}