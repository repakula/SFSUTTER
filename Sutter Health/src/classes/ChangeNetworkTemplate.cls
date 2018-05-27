/**
    @Author      : IDC Offshore
    @name        : ChangeNetworkTemplate Class
    @CreateDate  : 07/04/2015 (DD/MM/YYYY)
    @Description : Used for PDV Requirement REQ#3399.This class is for changing the Change Password Template on the Community SutterProvider Hub
    @Version     : 1.0
    @reference   : NA
 */





    public class ChangeNetworkTemplate {
    

     /**
     @Author      : IDC Offshore
     @name        : ChangeTemplate method
     @CreateDate  : 07/04/2015 (DD/MM/YYYY)
     @Description : Used for PDV Requirement REQ#3399.This method is for changing the Change Password Template on the Community SutterProvider Hub and receives Templateid as parameter.
     @Version     : 1.0
     @reference   : NA
     **/
     
     public void ChangeTemplate(String strTemplateId){

     String instanceurl,strToken,strUsername,strPassword,strEncodedPassword,strResponsebody,strInstanceURL;
     /** Fetching the Username and password from the Custom Setting in order to get the security token **/
     
     AccessTokenSetting__c objCredentials=AccessTokenSetting__c.getValues('Administrator');
     strUsername = objCredentials.Username__c;
     strEncodedPassword = objCredentials.Password__c;
     
     /** Decoding the password and getting its original value **/
     
     Blob objPwdBlob = EncodingUtil.base64decode(strEncodedPassword);
     strPassword = objPwdBlob.toString();
     
     
     /** Creating HTTP Request to get the token.In the body we are passing the values required to generate the token. **/
     
     HttpRequest req = new HttpRequest();
     req.setEndpoint(System.Label.End_Point);
     req.setMethod('POST');
     req.setBody('grant_type=password&client_id='+System.Label.Consumer_Key+'&client_secret='+System.Label.Consumer_Secret+'&username='+strUsername+'&password='+strPassword);


     
     
     /** Sending the request and fetching its response **/
     
     Http http = new Http();
     HTTPResponse res = http.send(req);
     
     strResponsebody = res.getBody();
     
     
     /** Fetching the related Community and its ChangePassword Template**/
     Network NetworkTemplate = [SELECT ChangePasswordEmailTemplateId, Id FROM Network WHERE Name = 'Sutter Provider Hub'];
    
     /** Parsing the returned response in order to get the instance's URL and the Access Token value **/
     
     JSONParser parser = JSON.createParser(strResponsebody);
     while (parser.nextToken() != null) {
        
        if (parser.getText() == 'access_token') {
            parser.nextToken();
            strToken = parser.getText();
            
        }

        if (parser.getText() == 'instance_url') {
            parser.nextToken();
            instanceurl = parser.getText();
            
        }
     }
     

    /** The below code sends a new request using the Instance URL and Access Token fetched from the previous Request's response and updates the Change Password template in the Community **/
     
     HttpRequest reqTemplateUpdate = new HttpRequest();
     if(instanceurl!=null)
     strInstanceURL = instanceurl.toLowerCase();
     
     String frameurl = strInstanceURL  + System.Label.Network_Label + NetworkTemplate.id + '?_HttpMethod=PATCH';
     system.debug('URL'+ frameurl );
      
     reqTemplateUpdate.setEndpoint(frameurl);
     reqTemplateUpdate.setHeader('Authorization', 'Bearer ' + strToken);
     reqTemplateUpdate.setHeader('Content-Type', 'application/json');
     reqTemplateUpdate.setMethod('POST');
     reqTemplateUpdate.setBody('{ "ChangePasswordEmailTemplateId" : "'+strTemplateId+'" }');
         
     HTTPResponse responseObj = http.send(reqTemplateUpdate);
     
    
     }  
    
    }