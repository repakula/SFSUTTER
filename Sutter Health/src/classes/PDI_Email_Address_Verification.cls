/**  
*     Class Name  : PDI_Email_Address_Verification
*     Author      : Kishore Jonnadula
*     Date        : 02/11/2016
*     Project Name: SOC Sutter Health
*     Description : PDI_Email_Address_Verification Class to verify the provider Email Address.
*/
public class PDI_Email_Address_Verification {
    public static final string reXml1_constant = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.strikeiron.com" xmlns:str="http://www.strikeiron.com/">'
        +'<soapenv:Header><ws:LicenseInfo><ws:RegisteredUser><ws:UserID>'; 
    public static final string reXml2_constant = '</ws:UserID><ws:Password>';
    public static final string reXml3_constant = '</ws:Password></ws:RegisteredUser></ws:LicenseInfo></soapenv:Header><soapenv:Body>'
            +'<str:VerifyEmail><str:Email>';
	public static final string emailEndtag_constant = '</str:Email>';   
    public static final string timeoutStarttag_constant = '<str:Timeout>';
    public static final string timeoutEndtag_constant = '</str:Timeout>';
    public static final string sourceIdStarttag_constant = '<str:OptionalSourceId>';
    public static final string sourceIdEndtag_constant = '</str:OptionalSourceId>';
    public static final string envelopeEndtags_constant = '</str:VerifyEmail></soapenv:Body></soapenv:Envelope>';
    public static final String emailService_constant = 'EmailAddressService';
    public static final String namespace_constant = 'http://schemas.xmlsoap.org/soap/envelope/';
    public static final String namespace1_constant = 'http://www.strikeiron.com/';
    public static final String body_constant = 'Body';
    public static final String verifyEmailResponse_constant = 'VerifyEmailResponse';
    public static final String verifyEmailResult_constant = 'VerifyEmailResult';
    public static final String serviceStatus_constant = 'ServiceStatus';
    public static final String statusNbr_constant = 'StatusNbr';
    public static final String statusDescription_constant = 'StatusDescription';
    public static final String serviceResult_constant = 'ServiceResult';
    public static final String hygieneResult_constant = 'HygieneResult';
    public static final String sourceIdentifier_constant = 'SourceIdentifier';
    
    /*
    * @description  :   This method is to make webservice call to verify the provider Email Address. 
    * @param        :   emailAddress
    * @return       :   List<wrapEmailVerification>
    */
    public static List<wrapEmailVerification> emailAddressWebService(String emailAddress, String recordId){
        String requestMethod = '';
        String endPointURL = '';
        String host = '';
        String contentType = '';
        String soapAction = '';
        String userName = '';
        String password = '';
        String timeOutSec = '';
        String summaryId = recordId != null ? recordId : '';
        List<wrapEmailVerification> emailStatusList = new List<wrapEmailVerification>();
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        try{
            Map<string,PDIEmailAddressService__c> mapEmailserviceVals = PDIEmailAddressService__c.getAll();
            if(mapEmailserviceVals != null && !mapEmailserviceVals.isEmpty()){
                requestMethod = mapEmailserviceVals.get(emailService_constant).RequestMethod__c;
                endPointURL = mapEmailserviceVals.get(emailService_constant).Endpoint__c;
                host = mapEmailserviceVals.get(emailService_constant).Host__c;
                contentType = mapEmailserviceVals.get(emailService_constant).Content_Type__c;
                soapAction = mapEmailserviceVals.get(emailService_constant).soapAction__c;
                userName = mapEmailserviceVals.get(emailService_constant).UserName__c;
                password = mapEmailserviceVals.get(emailService_constant).password__c;
                timeOutSec = mapEmailserviceVals.get(emailService_constant).TimeOut__c; 
            }
            req.setMethod(requestMethod);
            req.setEndpoint(endPointURL);
            req.setHeader(Label.CL536_PDI_AD_HOST, host);
            req.setHeader(Label.CL537_PDI_AD_contentType, contentType);
            req.setHeader(Label.CL538_PDI_SOAPACTION, soapAction);
            String reqXml = reXml1_constant + userName + reXml2_constant + password + reXml3_constant + emailAddress + emailEndtag_constant 
                + timeoutStarttag_constant + timeOutSec + timeoutEndtag_constant
                + sourceIdStarttag_constant + summaryId + sourceIdEndtag_constant+envelopeEndtags_constant;
            
            req.setBody(reqxml);
            String responseXml = '';
            if(!Test.isRunningTest()){
                HttpResponse response = ht.send(req);
                if(response.getStatusCode() == 200){ responseXml = response.getBody(); }
            }else{
                responseXml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
                    +'<Header xmlns="http://schemas.xmlsoap.org/soap/envelope/"><SubscriptionInfo xmlns="http://ws.strikeiron.com">'
                    +'<LicenseStatusCode>0</LicenseStatusCode><LicenseStatus>Valid license key</LicenseStatus><LicenseActionCode>0</LicenseActionCode><LicenseAction>Decremented hit count</LicenseAction>'
                    +'<RemainingHits>499113</RemainingHits><Amount>0</Amount></SubscriptionInfo></Header><soap:Body><VerifyEmailResponse xmlns="http://www.strikeiron.com/"><VerifyEmailResult><ServiceStatus><StatusNbr>210</StatusNbr><StatusDescription>Domain Confirmed</StatusDescription></ServiceStatus>'
                    +'<ServiceResult><Reason><Code>211</Code><Description>Server Will Accept</Description></Reason><HygieneResult>Safe US</HygieneResult><NetProtected>true</NetProtected>'
                    +'<NetProtectedBy>ProofPoint Threat Intelligence (SORBS parent)</NetProtectedBy><SourceIdentifier></SourceIdentifier>'
                    +'<Email>kishore.jonnadula@accenture.com</Email><LocalPart>kishore.jonnadula</LocalPart><DomainPart>accenture.com</DomainPart><IronStandardCertifiedTimestamp xsi:nil="true" />'
                    +'<DomainKnowledge /><AddressKnowledge /></ServiceResult></VerifyEmailResult></VerifyEmailResponse></soap:Body></soap:Envelope>';
            }
            if(String.isNotBlank(responseXml)){
                emailStatusList = parseResponse(responseXml);
            }
        }catch(System.CalloutException ex){
            System.debug(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }catch(Exception classException){
            System.debug(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
        return emailStatusList;
    }
    /*
    * @description  :   This method is to parse Email Address verification response. 
    * @param        :   String
    * @return       :   List<wrapEmailVerification>
    */
    public static List<wrapEmailVerification> parseResponse(String respXML){
        List<wrapEmailVerification> emailStatusList = new List<wrapEmailVerification>();
        String statusNum = '';
        String description = '';
        String hygienResult = '';
        String errorMsg = '';
        String recordId = '';
        
        Dom.Document respDom = new Dom.Document();
        respDom.load(respXML);
        Dom.XMLNode respEnv = respDom.getRootElement();
        
        Dom.XMLNode respBody1 = respEnv.getChildElement(body_constant, namespace_constant)
            .getChildElement(verifyEmailResponse_constant, namespace1_constant)
            .getChildElement(verifyEmailResult_constant, namespace1_constant);
                
        if (respBody1.getName() == verifyEmailResult_constant){
            for(Dom.XMLNode respBodyChild : respBody1.getChildElements()){
                if(respBodyChild.getName() == serviceStatus_constant){
                    Dom.XMLNode serviceStatusChild = respBody1.getChildElement(serviceStatus_constant, namespace1_constant);
                    for(Dom.XMLNode satusChild : serviceStatusChild.getChildElements()){
                        if(satusChild.getName() == statusNbr_constant){
                            statusNum = satusChild.getText();
                        }else if(satusChild.getName() == statusDescription_constant){
                            description = satusChild.getText();
                        }
                    }
                }else if(respBodyChild.getName() == serviceResult_constant){
                    Dom.XMLNode serviceResultChild = respBody1.getChildElement(serviceResult_constant, namespace1_constant);
                    for(Dom.XMLNode serviceResChild : serviceResultChild.getChildElements()){
                        if(serviceResChild.getName() == hygieneResult_constant){
                            hygienResult = serviceResChild.getText();
                        }else if(serviceResChild.getName() == sourceIdentifier_constant){
                            recordId = serviceResChild.getText();
                        }
                    }
                }
            }
            emailStatusList.add(new wrapEmailVerification(errorMsg, statusNum, description, hygienResult, recordId));
        }
        return emailStatusList;
    }
    /*
    * @description  :   Email Verification Wrapper Class 
    * @param        :   N/A
    * @return       :   N/A
    */
    public class wrapEmailVerification{
        public String statusNumber{get;set;}
        public String statusDescription{get;set;}
        public String hygeineResult{get;set;}
        public String errorMessage{get;set;}
        public String summaryId{get;set;}
        
        public wrapEmailVerification(String errorMsg, String statusNum, String description, String hygienResult, String recordId)
        {
            errorMessage = errorMsg;
            statusNumber = statusNum;
            statusDescription = description;
            hygeineResult = hygienResult;
            summaryId = recordId;
        }
    }
    
}