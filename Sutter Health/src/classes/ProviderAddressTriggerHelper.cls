/**  
*    Class Name: ProviderAddressTriggerHelper 
*    Date: 03-11-2016
*    Created By: IDC Offshore		
*    Description: This is a helper class for provider address trigger
**/
public class ProviderAddressTriggerHelper {
    public static boolean firstRunAddressBeforeInsert = true;
    public static boolean firstRunAddressAfterInsert = true;
    public static boolean firstRunAddressBeforeUpdate = true;
    public static boolean firstRunAddressAfterUpdate = true;
    
    // As per the discussion with Arieh, Commenting the below lines, to dont make address doctor callouts to 
    // verify the address information, whil pushing data from ETL.
    // Please uncomment from line no : 17 to 266 to verify the address through Address Doctor Webservice, while pushing data from ETL. 
    
    /*
* @description  :   This method is to make webservice call to verify more than one address. 
* @param        :   addressSet
* @return       :   Void
*/
    /*@future (callout=true)
public static void bulkAddressVerificationWebservice(Set<ID> addressIds)
{
SystemException__c systemException = new SystemException__c();
Http ht = new Http();
HttpRequest req = new HttpRequest();
List<Provider_Address__c> providerAddressList = new List<Provider_Address__c>();
Set<String> correctAddrCodeSet = new Set<String>();
Set<String> verifiedAddrCodeSet = new Set<String>();
Set<String> errorAddrCodeSet = new Set<String>();
Map<Integer, String> statusMap = new Map<Integer, String>();
Map<String, String> resultStatusMap = new Map<String, String>();
String elementResult = '';
String requestMethod = '';
String endPointURL = '';
String host = '';
String contentType = '';
String soapAction = '';
String processMode = '';
String userName = '';
String password = '';
String testAddressId = '';
try
{ 
// Address Doctor Each element status map Starts 
for (PDIAddressElementStatus__c eleStatus : PDIAddressElementStatus__c.getAll().values()){
statusMap.put(Integer.valueOf(eleStatus.Name), eleStatus.Value__c);
}
// Address Doctor Each element status result map Ends
// Address Doctor valid or Invalid result map Starts
for (PDIResultStatusCodes__c eleStatus : PDIResultStatusCodes__c.getAll().values()){
resultStatusMap.put(eleStatus.Name, eleStatus.value__c);
}
// Address Doctor valid or Invalid result map Ends 
// Address Doctor Correct Address Code Set Starts
for (PDIADCorrectAddressCodes__c addrCodes : PDIADCorrectAddressCodes__c.getAll().values()){
correctAddrCodeSet.add(addrCodes.Name);
}
// Address Doctor Correct Address Code Set Ends
// Address Doctor Verified Address Codes Set Starts
for (PDIADVerificationCodes__c verifiedCode : PDIADVerificationCodes__c.getAll().values()){
verifiedAddrCodeSet.add(verifiedCode.Name);
}
// Address Doctor Verified Address Codes Set Ends
// Address Doctor InCorrect Address Codes Set Starts
for (PDIADErrorCodes__c processErrCode : PDIADErrorCodes__c.getAll().values()){
errorAddrCodeSet.add(processErrCode.Name);
}
Map<string,PDIAddressDoctorService__c> mapCodes = PDIAddressDoctorService__c.getAll();
if(mapCodes != null && !mapCodes.isEmpty()){
requestMethod = mapCodes.get(Label.CL535_PDI_ADWebService).RequestMethod__c;
endPointURL = mapCodes.get(Label.CL535_PDI_ADWebService).Endpoint__c;
host = mapCodes.get(Label.CL535_PDI_ADWebService).Host__c;
contentType = mapCodes.get(Label.CL535_PDI_ADWebService).Content_Type__c;
soapAction = mapCodes.get(Label.CL535_PDI_ADWebService).soapAction__c;
processMode = mapCodes.get(Label.CL535_PDI_ADWebService).Batch_Process_Mode__c;
userName = mapCodes.get(Label.CL535_PDI_ADWebService).UserName__c;
password = mapCodes.get(Label.CL535_PDI_ADWebService).password__c;
}
List<Provider_Address__c> addressList = new List<Provider_Address__c>();
addressList=  [select id,Serial_Number__c,Contact_Id__c, Address_Line1__c, Address_Line_2__c, City__c, State__c
, Zip_Code__c, County__c, Provider_Address_AD_Status__c, Address_Mailability_Score__c
, Address_Result_Percentage__c from Provider_Address__c where Id IN :addressIds LIMIT 50000];
req.setMethod(requestMethod);
req.setEndpoint(endPointURL);
req.setHeader(Label.CL536_PDI_AD_HOST, host);
req.setHeader(Label.CL537_PDI_AD_contentType, contentType);
req.setHeader(Label.CL538_PDI_SOAPACTION, soapAction);

String reqXml =  Label.CL478_PDI_EnvelopeStart + Label.CL479_PDI_bodystart + Label.CL480_PDI_process_Start
+ Label.CL481_PDI_Login_Start + userName + Label.CL482_PDI_Login_End
+ Label.CL483_PDI_password_Start + password + Label.CL484_PDI_password_End + Label.CL485_PDI_parameters_Start
+ Label.CL486_PDI_ProcessMode_Start + processMode +Label.CL486_PDI_ProcessMode_End + Label.CL485_PDI_parameters_End
+ Label.CL491_PDI_Addressess_start;
String body = '';
for(Provider_Address__c address : addressList){
testAddressId = address.Id;
String addressLine1 = address.Address_Line1__c == null ? '' : address.Address_Line1__c;
String addressLine2 = address.Address_Line_2__c == null ? '' : address.Address_Line_2__c;
String city = address.City__c == null ? '' : address.City__c;
String state = address.State__c == null ? '' : address.State__c;
String zipCode = address.Zip_Code__c == null ? '' : address.Zip_Code__c;
String county = address.County__c == null ? '' : address.County__c;
String reqBody = Label.CL492_PDI_Address_Start
+ Label.CL539_PDI_Req_RecordID_Start+ address.Id +Label.CL540_PDI_Req_RecordID_End
+ Label.CL493_PDI_Street_Start + addressLine1 + Label.CL494_PDI_Street_End
+ Label.CL495_PDI_Building_Start + Label.CL496_PDI_Building_End
+ Label.CL497_PDI_SubBuilding_Start + addressLine2 + Label.CL497_PDI_SubBuilding_End
+ Label.CL498_PDI_City_Start + city + Label.CL499_PDI_City_End
+ Label.CL500_PDI_State_Start + state + Label.CL501_PDI_State_End
+ Label.CL502_PDI_ZipCode_Start + zipCode + Label.CL503_PDI_ZipCode_End 
+ Label.CL504_PDI_Country + Label.CL505_PDI_Address_End;
body += reqBody;
}
if(!String.isBlank(body)){
reqXml += body;
reqXml += Label.CL506_PDI_Addresses_End + Label.CL507_PDI_Soapbody_End;
req.setBody(reqxml);
}
String responseXml = '';
HttpResponse response;
if(!Test.isRunningTest()){ response = ht.send(req); System.debug(':::Response Code:::'+response.getStatusCode());
if(response.getStatusCode() == 200){ responseXml = response.getBody(); }else{ System.debug(Label.CL565_PDI_serviceErrorMsg); }
}else{
responseXml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ProcessResponse xmlns="http://validator5.AddressDoctor.com/Webservice5/v2"><ProcessResult><StatusCode>100</StatusCode><StatusMessage>OK</StatusMessage><Results><Result><ProcessStatus>C3</ProcessStatus><CountryISO3>USA</CountryISO3><ResultDataSet><ResultData><ResultNumber>1</ResultNumber><MailabilityScore>4</MailabilityScore><ResultPercentage>81.00</ResultPercentage><ElementInputStatus>40606050600000200060</ElementInputStatus><ElementResultStatus>78F0F8E0F000004000E0</ElementResultStatus><ElementRelevance>11101010100000100010</ElementRelevance><ExtElementStatus>00000000000000B00000</ExtElementStatus><AddressResolutionCode>00000000000000000000</AddressResolutionCode><AddressType>S</AddressType><LanguageISO3>ENG</LanguageISO3><Address><RecordId>'+testAddressId+'</RecordId><SubBuilding><string>APT 129</string></SubBuilding><Street><string>A ST</string></Street><HouseNumber><string>1401</string></HouseNumber><Locality><string>SACRAMENTO</string></Locality><PostalCode><string>95811-0631</string></PostalCode><Province><string>CA</string><string>SACRAMENTO</string></Province><Country><string>UNITED STATES</string></Country><DeliveryAddressLines><string>1401 A ST APT 129</string></DeliveryAddressLines><CountrySpecificLocalityLine><string>SACRAMENTO CA 95811-0631</string></CountrySpecificLocalityLine><FormattedAddress><string>1401 A ST APT 129</string><string>SACRAMENTO CA 95811-0631</string><string>UNITED STATES</string></FormattedAddress><AddressComplete>1401 A ST APT 129;SACRAMENTO CA 95811-0631;UNITED STATES</AddressComplete></Address></ResultData></ResultDataSet></Result></Results></ProcessResult></ProcessResponse></soap:Body></soap:Envelope>';
}
if(String.isNotBlank(responseXml)){
List<wrapAddressAD> addressesList = new List<wrapAddressAD>();
addressesList = parseResponse(responseXml);
if(!addressesList.isEmpty()){
for(wrapAddressAD addr : addressesList){
Provider_Address__c provAddress = new Provider_Address__c();
elementResult = '';
if(addr.errorMessage != null && !String.isBlank(addr.errorMessage)){
System.debug('Address Status Message::::'+addr.errorMessage); // To log the error message, if we get error message as response with correct result.
}else{
provAddress.Id = addr.addressId;
provAddress.Provider_Address_AD_Status__c = addr.addressProcessStatus;
provAddress.Address_Mailability_Score__c = addr.addressScore;
provAddress.Address_Result_Percentage__c = addr.addressResultPercentage;

if(addr.addressElementResultStatus != null){
String[] responseEleStatusStr = addr.addressElementResultStatus.split('');
for(Integer key : statusMap.keySet()){
if(responseEleStatusStr.get(key) != '0'){
String addrValue = statusMap.get(key);
elementResult += '<b>'+ addrValue + ':</b>&nbsp;&nbsp;'+ resultStatusMap.get(responseEleStatusStr.get(key)) + '<br/>';
}
} 
}
provAddress.AD_Element_Result_status__c = elementResult;

if(addr.addressProcessStatus != null){
if(correctAddrCodeSet.contains(addr.addressProcessStatus)){
provAddress.AD_Address_Verification_Status__c = Label.CL475_PDI_ADCorrect;
}else if(verifiedAddrCodeSet.contains(addr.addressProcessStatus)){
provAddress.AD_Address_Verification_Status__c = Label.CL476_PDI_AD_Verified;
}else if(errorAddrCodeSet.contains(addr.addressProcessStatus)){
provAddress.AD_Address_Verification_Status__c = Label.CL477_PDI_AD_InCorrect;
}
}
provAddress.Tech_Find_suggestAddress__c = true;
providerAddressList.add(provAddress);
}
}
}
if(!providerAddressList.isEmpty()){
update providerAddressList;
}

}
}catch(System.AsyncException ex){ 
systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
}catch(Exception classException){
systemException.ExceptionMessage__c = classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException;
}
}
*/
    /*
* @description  :   This method is to parse the bulk address response. 
* @param        :   String
* @return       :   List<wrapAddressAD>
*/
    /*
public static List<wrapAddressAD> parseResponse(String respXML){
SystemException__c systemException = new SystemException__c();
Map<String, String> serviceStatusMap = new Map<String, String>();
String processStatus = '';
String mailabilityScore = '';
String resultPercentage = '';
String recordId = '';
String resultStatus = '';
String errorMessage = '';

Dom.Document respDom = new Dom.Document();
respDom.load(respXML);
Dom.XMLNode respEnv = respDom.getRootElement();
List<wrapAddressAD> addressADList = new List<wrapAddressAD>();

try{
for (PDIADStatusCodes__c status : PDIADStatusCodes__c.getAll().values()){
serviceStatusMap.put(status.Name, status.Status_Message__c);
}

Dom.XMLNode respBody = respEnv.getChildElement(Label.CL510_PDI_Response_Body, Label.CL509_PDI_Response_Envelope)
.getChildElement(Label.CL511_PDI_Resp_ProcessResponse, Label.CL508_PDI_Response_Element)
.getChildElement(Label.CL512_PDI_Resp_ProcessResult, Label.CL508_PDI_Response_Element);

String statusCode = respBody.getChildElement(Label.CL513_PDI_Resp_StatusCode, Label.CL508_PDI_Response_Element).getText();

if(Label.CL514_PDI_StatusValue.equalsIgnoreCase(statusCode)){

Dom.XMLNode resultsNode = respBody.getChildElement(Label.CL515_PDI_Resp_Results, Label.CL508_PDI_Response_Element);
for(Dom.XMLNode resultAddrNode : resultsNode.getChildElements()){
if (resultAddrNode.getName() == Label.CL516_PDI_Resp_Result){
for(Dom.XMLNode resultChild : resultAddrNode.getChildElements()){
if(resultChild.getName() == Label.CL517_PDI_Resp_ProcessStatus){
processStatus = resultChild.getText();
}else if(resultChild.getName() == Label.CL518_PDI_Resp_ResultDataSet){
Dom.XMLNode datasetNode = resultAddrNode.getChildElement(Label.CL518_PDI_Resp_ResultDataSet, Label.CL508_PDI_Response_Element);

for(Dom.XMLNode resultDataInfo : datasetNode.getChildElements()){
if(resultDataInfo.getName() == Label.CL519_PDI_Resp_ResultData){
for(Dom.XMLNode respData : resultDataInfo.getChildElements()) 
{
if(respData.getName() == Label.CL520_PDI_MailabilityScore){
mailabilityScore = respData.getText();
}else if(respData.getName() == Label.CL521_PDI_ResultPercentage){
resultPercentage = respData.getText();
}else if(respData.getName() == Label.CL522_PDI_ElementResultStatus){
resultStatus = respData.getText();
}else if (respData.getName() == Label.CL523_PDI_Resp_Address){
for(Dom.XMLNode licChild : respData.getChildElements()){
if(licChild.getName() == Label.CL534_PDI_Resp_RecordId){
recordId = licChild.getText();
}
}
}
}
}//Result Data if Ends
}
}
}
addressADList.add(new wrapAddressAD(errorMessage, recordId, processStatus, mailabilityScore, resultPercentage, resultStatus)); 
}// Main if Condition
}// Main For loop
}// Status if condition
else{
if(serviceStatusMap.containsKey(statusCode)){
errorMessage = serviceStatusMap.get(statusCode);
addressADList.add(new wrapAddressAD(errorMessage, recordId, processStatus, mailabilityScore, resultPercentage, resultStatus));
}
}
}catch(Exception ex){
systemException.ExceptionMessage__c = ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now(); insert systemException; return null;
}
return addressADList;
}

public String selectedRecord{get;set;}
*/
    /*
* @description  :   This class is wrapper class for Verified Address. 
* @return       :   N/A
*/
    /*
public class wrapAddressAD{
public Boolean selected {get; set;}
public String addressProcessStatus{get;set;}
public String addressScore{get;set;}
public String addressResultPercentage{get;set;}
public String addressElementResultStatus{get;set;}
public String addressId{get;set;}
public String errorMessage{get;set;}

public wrapAddressAD(String errorMsg, String recordId, String processStatus, String mailabilityScore, String resultPercentage, String resultStatus)
{
errorMessage = errorMsg;
addressId = recordId;
selected = false;
addressProcessStatus = processStatus;
addressScore = mailabilityScore;
addressResultPercentage = resultPercentage;
addressElementResultStatus = resultStatus;
}
}
*/
    /*
Method Name: updateAddressSerialNumber
input Param: Provider_Address__c List, String
return type: void
Description: To update the secondary address serial numbers
*/
    public static void updateAddressSerialNumber(List<Provider_Address__c> addressList, String userProfile){
        Set<Id> setContactIds = new Set<Id>();
        Map<Id,Provider_Address__c> mapContactToSummary = new Map<Id,Provider_Address__c>();
        Map<String,Integer> mapContactIdToNumber = new Map<String,Integer>();
        Map<Id, Id> conSumMap = new Map<Id, Id>();
        List<Contact_Validation_Summary__c> currentCampaignList = new List<Contact_Validation_Summary__c>();
        for(Provider_Address__c objAddress:addressList) {
            setContactIds.add(objAddress.Contact_Id__c);
        }
        //PDI Wave2: Added logic to map currect summary ids to address records from ETL job
        currentCampaignList = [Select Id, Contact_Id__c, PDI_Campaign__c From Contact_Validation_Summary__c 
                               Where Contact_Id__c IN: setContactIds AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
        if(!currentCampaignList.isEmpty()){
            for(Contact_Validation_Summary__c sum: currentCampaignList){
                conSumMap.put(sum.Contact_Id__c, sum.Id); 
            }
        }
        for(Provider_Address__c objAddress:addressList) {
            if(objAddress.Summary_Id__r.PDI_Campaign__c != Label.CL176_PDI_Current_Campaign_Name && conSumMap.containsKey(objAddress.Contact_Id__c)){
                objAddress.Summary_Id__c = conSumMap.get(objAddress.Contact_Id__c);
            }
        }
        //PDI Wave2: Added logic to map currect summary ids to address records from ETL job Ended
        //Querying the contact ids and secondary address serial numbers on provider address records
        AggregateResult[] addressResults = [SELECT Contact_Id__c, COUNT(Serial_Number__c) FROM Provider_Address__c where Contact_Id__c in: setContactIds and Address_Type__c =: Label.CL359_PDI_secondaryAddress GROUP BY Contact_Id__c LIMIT 10000];
        if(!addressResults.isEmpty()){
            for (AggregateResult ar : addressResults)  {
                mapContactIdToNumber.put(String.valueOf(ar.get('Contact_Id__c')), Integer.valueOf(ar.get('expr0')));
            } 
        }
        
        for(Provider_Address__c addressObj :  addressList) {
            //Replacing prefix 1 from the 11 digits provider phone number and upating phone number on tech phone number without any special characters
            if(String.isNotBlank(addressObj.Secure_Phone__c)){
                addressObj.Tech_Phone_Number__c = addressObj.Secure_Phone__c.replaceAll('[^0-9]','');
                if(addressObj.Tech_Phone_Number__c.length() > 10){
                    addressObj.Tech_Phone_Number__c = addressObj.Tech_Phone_Number__c.SubString(0,1).Contains('1') ? 
                        addressObj.Tech_Phone_Number__c.SubString(1, addressObj.Tech_Phone_Number__c.Length()): addressObj.Tech_Phone_Number__c;                    
                }
            }
            //Setting serial numbers for provider secondary addresses
            if((addressObj.Serial_Number__c == null || String.isBlank(addressObj.Serial_Number__c)) && !Label.CL471_PDI_EPICAddressInactive.equalsIgnoreCase(addressObj.EPIC_Address_Status__c))
            {
                if(Label.CL359_PDI_secondaryAddress.equalsIgnoreCase(addressObj.address_type__c)){
                    if(addressObj.Contact_Id__c != null && mapContactIdToNumber != null 
                       && mapContactIdToNumber.containsKey(addressObj.Contact_Id__c)) 
                    {
                        if(mapContactIdToNumber.get(addressObj.Contact_Id__c) != null) {
                            addressObj.Serial_Number__c = String.valueOf(mapContactIdToNumber.get(addressObj.Contact_Id__c) + 1);
                        } 
                    }else {
                        addressObj.Serial_Number__c = '1';
                    }
                    mapContactIdToNumber.put(addressObj.Contact_Id__c, Integer.valueOf(addressObj.Serial_Number__c));
                }else{
                    if(Label.CL263_PDI_PrimaryAddress.equalsIgnoreCase(addressObj.address_type__c)){
                        addressObj.Serial_Number__c = '0';
                    }
                }
            }// if ends
            addressObj.Address_Status__c = Label.CL474_PDI_NewAddress;
            addressObj.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            if(userProfile != null && userProfile == Label.CL561_PDIIntegrationProfile){ addressObj.Tech_Is_Address_Updated__c = false; }
        }//for loop ends
    }
    /*
Method Name: updatePrimaryAddressOnSummary
input Param: Map
return type: void
Description: To update the provider address on summary object
*/
    public static void updatePrimaryAddressOnSummary(Map<Id, Provider_Address__c> sumPrimaryMap){
        List<Contact_Validation_Summary__c> sumList = new List<Contact_Validation_Summary__c>();
        //Updating provider primary address on summary object
        for(Contact_Validation_Summary__c sum :  [Select Id, Tech_Phone_Number__c From Contact_Validation_Summary__c 
                                                  Where Id IN : sumPrimaryMap.keySet()]) {
                                                      sum.Address_Type__c = sumPrimaryMap.get(sum.Id).Address_Type__c;
                                                      sum.Secure_Street_Address__c = sumPrimaryMap.get(sum.Id).Address_Line1__c;
                                                      sum.Address_Line_2__c = sumPrimaryMap.get(sum.Id).Address_Line_2__c;
                                                      sum.Secure_City__c = sumPrimaryMap.get(sum.Id).City__c;
                                                      sum.Secure_State__c = sumPrimaryMap.get(sum.Id).State__c;
                                                      sum.Secure_Phone_Ext__c = sumPrimaryMap.get(sum.Id).Secure_Phone_Ext__c;
                                                      sum.Secure_Fax__c = sumPrimaryMap.get(sum.Id).Secure_Fax__c;
                                                      sum.Secure_Zip_Code__c = sumPrimaryMap.get(sum.Id).Zip_Code__c;
                                                      if(sumPrimaryMap.get(sum.Id).Secure_Phone__c != null){
                                                          sum.Secure_Phone__c = sumPrimaryMap.get(sum.Id).Secure_Phone__c;
                                                          sum.Tech_Phone_Number__c = sumPrimaryMap.get(sum.Id).Secure_Phone__c.replaceAll('[^0-9]','');
                                                      }
                                                      sum.Decline_Phone__c = sumPrimaryMap.get(sum.Id).Decline_Phone__c;
                                                      sum.Decline_Fax__c = sumPrimaryMap.get(sum.Id).Decline_Fax__c;
                                                      sum.Tech_Success_Email__c = false;
                                                      sumList.add(sum);
                                                  }
        if(!sumList.isEmpty()){
            update sumList;
        }
    }
    
    /*
Method Name: updateAddressSerialNumber
input Param: Old Provider_Address__c List, New Provider_Address__c List, String
return type: void
Description: To update the secondary address serial numbers
*/
    public static void updateProviderAddressSerialNumbers(Map<id, Provider_Address__c> oldAddressMap, List<Provider_Address__c> newAddressList, String userProfile){
        Set<Id> setContactIds = new Set<Id>();
        Map<Id,String> oldSerialNumberMap = new Map<Id,String>();
        Map<Id,Provider_Address__c> mapContactToSummary = new Map<Id,Provider_Address__c>();
        Map<String,Integer> mapContactIdToNumber = new Map<String,Integer>();
        Map<Id, Id> conSumMap = new Map<Id, Id>();
        List<Contact_Validation_Summary__c> currentCampaignList = new List<Contact_Validation_Summary__c>();
        
        if(userProfile != null && userProfile == Label.CL561_PDIIntegrationProfile){
            for(Provider_Address__c objAddress:newAddressList) {
                setContactIds.add(objAddress.Contact_Id__c);
            }
            //PDI Wave2: Added logic to map currect summary ids to address records from ETL job
            currentCampaignList = [Select Id, Contact_Id__c, PDI_Campaign__c From Contact_Validation_Summary__c 
                                   Where Contact_Id__c IN: setContactIds AND PDI_Campaign__c =: Label.CL176_PDI_Current_Campaign_Name];
            if(!currentCampaignList.isEmpty()){
                for(Contact_Validation_Summary__c sum: currentCampaignList){
                    conSumMap.put(sum.Contact_Id__c, sum.Id); 
                }
            }
            for(Provider_Address__c objAddress:newAddressList) {
                if(objAddress.Summary_Id__r.PDI_Campaign__c != Label.CL176_PDI_Current_Campaign_Name && conSumMap.containsKey(objAddress.Contact_Id__c)){
                    objAddress.Summary_Id__c = conSumMap.get(objAddress.Contact_Id__c);
                }
            }
            //PDI Wave2: Added logic to map currect summary ids to address records from ETL job Ended
            //Querying the contact ids and secondary address serial numbers on provider address records
            AggregateResult[] addressResults = [SELECT Contact_Id__c, COUNT(Serial_Number__c) FROM Provider_Address__c where Contact_Id__c in: setContactIds and Address_Type__c =: Label.CL359_PDI_secondaryAddress GROUP BY Contact_Id__c LIMIT 10000];
            if(!addressResults.isEmpty()){
                for (AggregateResult ar : addressResults)  {
                    mapContactIdToNumber.put(String.valueOf(ar.get('Contact_Id__c')), Integer.valueOf(ar.get('expr0')));
                }
            }
            
            for(Provider_Address__c addressObj :  newAddressList) {
                Provider_Address__c oldProviderAddress = (Provider_Address__c)oldAddressMap.get(addressObj.id);
                if(Label.CL359_PDI_secondaryAddress.equalsIgnoreCase(oldProviderAddress.address_type__c) && Label.CL263_PDI_PrimaryAddress.equalsIgnoreCase(addressObj.address_type__c)){
                    oldSerialNumberMap.put(oldProviderAddress.Contact_Id__c, oldProviderAddress.Serial_Number__c);
                }
            }
            
            for(Provider_Address__c addressObj :  newAddressList) {
                Provider_Address__c oldProviderAddress = (Provider_Address__c)oldAddressMap.get(addressObj.id);
                if(Label.CL359_PDI_secondaryAddress.equalsIgnoreCase(addressObj.address_type__c)){
                    if(oldProviderAddress.Serial_Number__c == '0'){
                        if(!oldSerialNumberMap.isEmpty() && oldSerialNumberMap.containsKey(addressObj.Contact_Id__c)){
                            addressObj.Serial_Number__c = oldSerialNumberMap.get(addressObj.Contact_Id__c);
                        }
                    }
                    if(oldProviderAddress.EPIC_Address_Status__c == Label.CL471_PDI_EPICAddressInactive && addressObj.EPIC_Address_Status__c != Label.CL471_PDI_EPICAddressInactive){
                        
                        if(addressObj.Contact_Id__c != null && mapContactIdToNumber != null && mapContactIdToNumber.containsKey(addressObj.Contact_Id__c)) 
                        {
                            if(mapContactIdToNumber.get(addressObj.Contact_Id__c) != null) {
                                addressObj.Serial_Number__c = String.valueOf(mapContactIdToNumber.get(addressObj.Contact_Id__c) + 1);
                            } 
                        }else {
                            addressObj.Serial_Number__c = '1';
                        }
                        mapContactIdToNumber.put(addressObj.Contact_Id__c, Integer.valueOf(addressObj.Serial_Number__c));
                    }
                    if(addressObj.EPIC_Address_Status__c == Label.CL471_PDI_EPICAddressInactive){
                        addressObj.Serial_Number__c = null;
                    }
                }else{
                    if(Label.CL263_PDI_PrimaryAddress.equalsIgnoreCase(addressObj.address_type__c)){
                        addressObj.Serial_Number__c = '0';
                    }
                }
                addressObj.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
                addressObj.Tech_Is_Address_Updated__c = false;
            }
        }//Profile if cond Ends
        else{
            for(Provider_Address__c objAddress :  newAddressList) {
                Provider_Address__c oldAddress = (Provider_Address__c)oldAddressMap.get(objAddress.id);
                
                //Replacing prefix 1 from the 11 digits provider phone number and upating phone number on tech phone number without any special characters
                if(String.isNotBlank(objAddress.Secure_Phone__c) && oldAddress.Secure_Phone__c != objAddress.Secure_Phone__c){
                    objAddress.Tech_Phone_Number__c = objAddress.Secure_Phone__c.replaceAll('[^0-9]','');
                    objAddress.Tech_Phone_Number__c = objAddress.Tech_Phone_Number__c.SubString(0,1).Contains('1') ? 
                        objAddress.Tech_Phone_Number__c.SubString(1, objAddress.Secure_Phone__c.Length()): objAddress.Tech_Phone_Number__c;
                }
                //tracking changes on provider address changes
                if(objAddress.Tech_Is_Address_Updated__c == true){
                    if(objAddress.Is_Primary_Phone_Number_Changed__c==false && oldAddress.Secure_Phone__c!=objAddress.Secure_Phone__c)
                    {
                        String strOldValue = ExtractNumbersFromString.extractMethod(oldAddress.Secure_Phone__c);
                        String strNewValue = ExtractNumbersFromString.extractMethod(objAddress.Secure_Phone__c);
                        if(strOldValue!=strNewValue)
                            objAddress.Is_Primary_Phone_Number_Changed__c = true; // Setting the Phone Change Checkbox true
                    }
                    
                    if(objAddress.Is_Phone_Extension_Changed__c==false && oldAddress.Secure_Phone_Ext__c!=objAddress.Secure_Phone_Ext__c)
                    {
                        objAddress.Is_Phone_Extension_Changed__c = true; // Setting the Secure Phone Ext Change Checkbox true
                    }
                    if(objAddress.Is_Secure_Fax_Changed__c==false && oldAddress.Secure_Fax__c!=objAddress.Secure_Fax__c){
                        String strOldValue = ExtractNumbersFromString.extractMethod(oldAddress.Secure_Fax__c);
                        String strNewValue = ExtractNumbersFromString.extractMethod(objAddress.Secure_Fax__c);
                        
                        if(strOldValue!=strNewValue)
                            objAddress.Is_Secure_Fax_Changed__c = true; // Setting the Fax Change Checkbox true
                    }
                    if(objAddress.Is_Address_Type_Changed__c==false && oldAddress.Address_Type__c!=objAddress.Address_Type__c){
                        objAddress.Is_Address_Type_Changed__c = true; // Setting the Address Type Change Checkbox true
                    }
                    if(objAddress.Is_Direct_Address_Changed__c==false && oldAddress.Direct_Address__c!=objAddress.Direct_Address__c){
                        objAddress.Is_Direct_Address_Changed__c = true; // Setting the Direct Address Change Checkbox true
                    }
                    if(objAddress.Is_Address_Line_Changed__c==false 
                       && oldAddress.Address_Line1__c!=objAddress.Address_Line1__c)
                    {
                        objAddress.Is_Address_Line_Changed__c = true; // Setting the Address Line1 Change Checkbox true
                    }
                    if(objAddress.Is_Address_Line_2_Changed__c==false 
                       && oldAddress.Address_Line_2__c!=objAddress.Address_Line_2__c)
                    {
                        objAddress.Is_Address_Line_2_Changed__c = true; // Setting the Address Line2 Change Checkbox true
                    }
                    if(objAddress.Is_City_Changed__c==false && oldAddress.City__c!=objAddress.City__c){
                        objAddress.Is_City_Changed__c = true; // Setting the City Change Checkbox true
                    }
                    if(objAddress.Is_State_Changed__c==false && oldAddress.State__c!=objAddress.State__c){
                        objAddress.Is_State_Changed__c = true; // Setting the State Change Checkbox true
                    }
                    if(objAddress.Is_County_Changed__c==false && oldAddress.County__c!=objAddress.County__c){
                        objAddress.Is_County_Changed__c = true; // Setting the County Change Checkbox true
                    }
                    if(objAddress.Is_Zip_Code_Changed__c==false && oldAddress.Zip_Code__c!=objAddress.Zip_Code__c){
                        objAddress.Is_Zip_Code_Changed__c = true; // Setting the zip code Change Checkbox true
                    }  
                }
                objAddress.PDI_Campaign__c = Label.CL176_PDI_Current_Campaign_Name;
            }//For loop Ends
        }
    }
}