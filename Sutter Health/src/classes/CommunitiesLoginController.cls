/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
    
    global PageReference forwardToCustomAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
    // Change the default page redirect from /home/home.jsp to /login to support federated SSO buttons as well as username and password authentication.
       return new PageReference('/login');
       
       
     //   return new PageReference(Site.getPrefix() + '/customLogin?startURL=' +
    //    EncodingUtil.urlEncode(startURL, 'UTF-8'));
    }

}