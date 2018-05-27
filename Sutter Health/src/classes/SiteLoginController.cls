/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() 
    {
        //*** Code block added by Ramit (SFDC) ***//
        String str_pageURL = ApexPages.currentPage().getParameters().get('refURL');
        String startUrl;

        if(str_pageURL.contains('articles') && str_pageURL.contains('Policy'))
        {
            //*** Prepare startUrl string ***//
            Integer int_indexofarticle = str_pageURL.indexOf('article');
            str_pageURL = str_pageURL.subString(int_indexofarticle);
            system.debug('str_pageURL :::'+str_pageURL);
            startUrl='/'+str_pageURL+'?popup=true';
        }
        else
        {
            startUrl = '/home/home.jsp';
        }
        //****************END*********************//
  
        //String startUrl = System.currentPageReference().getParameters().get('startURL');//commented to add the above code block//
        return Site.login(username, password, startUrl);
    }
    
    global SiteLoginController () {}
}