/**  
*     Class Name  : PDI_Address_Verification
*     Author      : Kishore Jonnadula
*     Date        : 20/10/2016
*     Project Name: SOC Sutter Health
*     Description : PDI_Address_Verification Class to verify the Address details through Informatica Address Doctor.
*/
public class PDI_Address_Verification {
    /*
    * @description  :   This method is to make webservice call to verify the address. 
    * @param        :   address
    * @return       :   List<addressAD>
    */
    public static List<addressAD> checkProviderAddress(Provider_Address__c address){
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        List<addressAD> addressList = new List<addressAD>();
        List<Provider_Address__c> provAddressList = new List<Provider_Address__c>();
        String processStatus = '';
        String resultStatus = '';
        String requestMethod = '';
        String endPointURL = '';
        String host = '';
        String contentType = '';
        String soapAction = '';
        String processMode = '';
        String userName = '';
        String password = '';
        try{
            
            Map<string,PDIAddressDoctorService__c> mapCodes = PDIAddressDoctorService__c.getAll();
            if(mapCodes != null && !mapCodes.isEmpty()){
                requestMethod = mapCodes.get(Label.CL535_PDI_ADWebService).RequestMethod__c;
                endPointURL = mapCodes.get(Label.CL535_PDI_ADWebService).Endpoint__c;
                host = mapCodes.get(Label.CL535_PDI_ADWebService).Host__c;
                contentType = mapCodes.get(Label.CL535_PDI_ADWebService).Content_Type__c;
                soapAction = mapCodes.get(Label.CL535_PDI_ADWebService).soapAction__c;
                processMode = mapCodes.get(Label.CL535_PDI_ADWebService).ProcessMode__c;
                userName = mapCodes.get(Label.CL535_PDI_ADWebService).UserName__c;
                password = mapCodes.get(Label.CL535_PDI_ADWebService).password__c;
            }
            req.setMethod(requestMethod);
            req.setEndpoint(endPointURL);
            req.setHeader(Label.CL536_PDI_AD_HOST, host);
            req.setHeader(Label.CL537_PDI_AD_contentType, contentType);
            req.setHeader(Label.CL538_PDI_SOAPACTION, soapAction);
            if(address.Address_Line1__c != null){
                String addressLine1 = address.Address_Line1__c == null ? '' : address.Address_Line1__c;
                String addressLine2 = address.Address_Line_2__c == null ? '' : address.Address_Line_2__c;
                String city = address.City__c == null ? '' : address.City__c;
                String state = address.State__c == null ? '' : address.State__c;
                String zipCode = address.Zip_Code__c == null ? '' : address.Zip_Code__c;
                String county = address.County__c == null ? '' : address.County__c;
                
                String reqXml =  Label.CL478_PDI_EnvelopeStart + Label.CL479_PDI_bodystart + Label.CL480_PDI_process_Start 
                    			 + Label.CL481_PDI_Login_Start + userName + Label.CL482_PDI_Login_End
                                 + Label.CL483_PDI_password_Start + password + Label.CL484_PDI_password_End + Label.CL485_PDI_parameters_Start
                                 + Label.CL486_PDI_ProcessMode_Start + processMode +Label.CL486_PDI_ProcessMode_End
                    			 + Label.CL487_PDI_Validationparm_Start + Label.CL466_PDI_SuggestedAddressResultCount + Label.CL488_PDI_resultCount
                                 + 'ALL' + Label.CL489_PDI_RangestoExpand +'false'+ Label.CL490_PDI_validation_End + Label.CL485_PDI_parameters_End
                                 + Label.CL491_PDI_Addressess_start + Label.CL492_PDI_Address_Start
                                 + Label.CL493_PDI_Street_Start + addressLine1 + Label.CL494_PDI_Street_End
                                 + Label.CL495_PDI_Building_Start + Label.CL496_PDI_Building_End
                                 + Label.CL497_PDI_SubBuilding_Start + addressLine2 + Label.CL497_PDI_SubBuilding_End
                                 + Label.CL498_PDI_City_Start + city + Label.CL499_PDI_City_End
                                 + Label.CL500_PDI_State_Start + state + Label.CL501_PDI_State_End
                                 + Label.CL502_PDI_ZipCode_Start + zipCode + Label.CL503_PDI_ZipCode_End 
                                 + Label.CL504_PDI_Country + Label.CL505_PDI_Address_End + Label.CL506_PDI_Addresses_End + Label.CL507_PDI_Soapbody_End;
                req.setBody(reqxml);
                if(!Test.isRunningTest()){
                    HttpResponse response = ht.send(req);
                    if(response.getStatusCode() == 200){ String responseXml = response.getBody(); addressList = parseResponse(responseXml, false);
                    }else{
                        String errorMsg = Label.CL565_PDI_serviceErrorMsg; addressList.add(new addressAD(errorMsg, processStatus, resultStatus, provAddressList));  
                    }
                }else{
                    String testresponseXml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ProcessResponse xmlns="http://validator5.AddressDoctor.com/Webservice5/v2"><ProcessResult><StatusCode>100</StatusCode><StatusMessage>OK</StatusMessage><JobToken>c97489c3-d103-49aa-bbc1-15f92658032b</JobToken><Results><Result><ProcessStatus>I3</ProcessStatus><CountryISO3>USA</CountryISO3><ResultDataSet><ResultData><ResultNumber>1</ResultNumber><MailabilityScore>1</MailabilityScore><ResultPercentage>85.00</ResultPercentage><ElementInputStatus>60606060300000600060</ElementInputStatus><ElementResultStatus>F8F0F8F0300000F300E0</ElementResultStatus><ElementRelevance>11101010100000100010</ElementRelevance><ExtElementStatus>00000000000000000000</ExtElementStatus><AddressResolutionCode>00000000300000000000</AddressResolutionCode><AddressType>S</AddressType><LanguageISO3>ENG</LanguageISO3><Address><SubBuilding><string>ST 9999999</string></SubBuilding><Street><string>IRON POINT RD</string></Street><HouseNumber><string>100</string></HouseNumber><Locality><string>FOLSOM</string></Locality><PostalCode><string>95630-9000</string></PostalCode><Province><string>CA</string><string>SACRAMENTO</string></Province><Country><string>UNITED STATES</string></Country><DeliveryAddressLines><string>100 IRON POINT RD ST 9999999</string></DeliveryAddressLines><CountrySpecificLocalityLine><string>FOLSOM CA 95630-9000</string></CountrySpecificLocalityLine><FormattedAddress><string>100 IRON POINT RD ST 9999999</string><string>FOLSOM CA 95630-9000</string><string>UNITED STATES</string></FormattedAddress><AddressComplete>100 IRON POINT RD ST 9999999;FOLSOM CA 95630-9000;UNITED STATES</AddressComplete></Address></ResultData></ResultDataSet></Result></Results></ProcessResult></ProcessResponse></soap:Body></soap:Envelope>';
                    addressList = parseResponse(testresponseXml, false);
                }
                
            }
        }catch(System.CalloutException ex){ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(ex.getMessage() + Label.CL218_rSlashN + ex.getStackTraceString() + Label.CL218_rSlashN + ex.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }catch(Exception classException){ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
        return addressList;
    }
    
    /*
    * @description  :   This method is to parse the response. 
    * @param        :   String
    * @return       :   List<addressAD>
    */
    public static List<addressAD> parseResponse(String respXML, Boolean triggerVal){
        List<Provider_Address__c> provAddressList = new List<Provider_Address__c>();
        Map<String, String> serviceStatusMap = new Map<String, String>();
        Provider_Address__c addressObj;
        String processStatus = '';
        String houseNumber = '';
        String street = '';
        String building = '';
        String subBuilding = '';
        String formatAddress = '';
        String state = '';
        String county = '';
        String resultStatus = '';
        String errorMessage = '';
        String mailabilityScore ='';
        String resultPercentage ='';
        
        
        Dom.Document respDom = new Dom.Document();
        respDom.load(respXML);
        System.debug('respXML::::'+respXML);
        Dom.XMLNode respEnv = respDom.getRootElement();
        List<addressAD> addressADList = new List<addressAD>();
        
        try{
            for (PDIADStatusCodes__c status : PDIADStatusCodes__c.getAll().values()){
                serviceStatusMap.put(status.Name, status.Status_Message__c);
            }
            
            Dom.XMLNode respBody = respEnv.getChildElement(Label.CL510_PDI_Response_Body, Label.CL509_PDI_Response_Envelope)
                .getChildElement(Label.CL511_PDI_Resp_ProcessResponse, Label.CL508_PDI_Response_Element)
                .getChildElement(Label.CL512_PDI_Resp_ProcessResult, Label.CL508_PDI_Response_Element);
            
            String statusCode = respBody.getChildElement(Label.CL513_PDI_Resp_StatusCode, Label.CL508_PDI_Response_Element).getText();
            
            if(Label.CL514_PDI_StatusValue.equalsIgnoreCase(statusCode)){
                
                Dom.XMLNode resultsNode = respBody.getChildElement(Label.CL515_PDI_Resp_Results, Label.CL508_PDI_Response_Element)
                                                  .getChildElement(Label.CL516_PDI_Resp_Result, Label.CL508_PDI_Response_Element);
                    if (resultsNode.getName() == Label.CL516_PDI_Resp_Result){
                        for(Dom.XMLNode resultChild : resultsNode.getChildElements()){
                            if(resultChild.getName() == Label.CL517_PDI_Resp_ProcessStatus){
                                processStatus = resultChild.getText();
                            }else if(resultChild.getName() == Label.CL518_PDI_Resp_ResultDataSet){
                                Dom.XMLNode datasetNode = resultsNode.getChildElement(Label.CL518_PDI_Resp_ResultDataSet, Label.CL508_PDI_Response_Element);
                                
                                for(Dom.XMLNode resultDataInfo : datasetNode.getChildElements()){
                                    if(resultDataInfo.getName() == Label.CL519_PDI_Resp_ResultData){
                                        formatAddress = '';
                                        houseNumber = '';
                                        street = '';
                                        subBuilding = '';
                                        state = '';
                                        county = '';
                                        mailabilityScore ='';
        								resultPercentage ='';
                                        for(Dom.XMLNode respData : resultDataInfo.getChildElements()) 
                                        {
                                            addressObj = new Provider_Address__c();
                                            if(respData.getName() == Label.CL520_PDI_MailabilityScore){
                                                mailabilityScore = respData.getText();
                                            }else if(respData.getName() == Label.CL521_PDI_ResultPercentage){
                                                resultPercentage = respData.getText();
                                            }else if(respData.getName() == Label.CL522_PDI_ElementResultStatus){
                                                resultStatus = respData.getText();
                                            }else if (respData.getName() == Label.CL523_PDI_Resp_Address){
                                                for(Dom.XMLNode licChild : respData.getChildElements()){
                                                    if(licChild.getName() == Label.CL524_PDI_HouseNumber){
                                                        houseNumber = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL525_PDI_Resp_Street){
                                                        street = '' + licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL526_PDI_Resp_Building){
                                                        building = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL527_PDI_Resp_SubBuilding){
                                                        subBuilding = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL528_PDI_Resp_Locality){
                                                        addressObj.City__c = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL529_PDI_Resp_PostalCode){
                                                        addressObj.Zip_Code__c = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL530_PDI_Resp_Province){
                                                        for(Dom.XMLNode provinceChild : licChild.getChildElements()){
                                                            if(state == ''){
                                                                state = provinceChild.getText();
                                                            }else{
                                                                county = provinceChild.getText();
                                                            }
                                                        }
                                                    }else if(licChild.getName() == Label.Cl531_PDI_Resp_Country){
                                                        addressObj.Country__c = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL532_PDI_Resp_FormattedAddress){
                                                        for(Dom.XMLNode addrChild : licChild.getChildElements()){
                                                            formatAddress += ' '+ addrChild.getText();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        addressObj.Address_Line1__c = houseNumber + ' '+ street;
                                        addressObj.Address_Line_2__c = subBuilding;
                                        addressObj.Formatted_Address__c = formatAddress;
                                        addressObj.State__c = state;
                                        addressObj.County__c = county;
                                        addressObj.Provider_Address_AD_Status__c = processStatus;
                                        addressObj.Address_Mailability_Score__c = mailabilityScore;
                                        addressObj.Address_Result_Percentage__c = resultPercentage;
                                        provAddressList.add(addressObj);
                                    }//Result Data if Ends
                                }
                            }
                            if(!provAddressList.isEmpty()){
                               addressADList.add(new addressAD(errorMessage, processStatus, resultStatus, provAddressList));  
                            }
                        }
                    }// Main if Condition
            }// Status if condition
            else{
                if(serviceStatusMap.containsKey(statusCode)){
                    errorMessage = serviceStatusMap.get(statusCode);
                    addressADList.add(new addressAD(errorMessage, processStatus, resultStatus, provAddressList));
                }
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
        return addressADList;
    }
    
    public String selectedRecord{get;set;}
    
   /**  
    *     Author      : Kishore Jonnadula
    *     Description : Address Wrapper Class.
    */
    public class addressAD{
        public String errorStatus{get;set;}
        public String addressProcessStatus{get;set;}
        public String elementResultStatus{get;set;}
        public List<Provider_Address__c> verifiedProvAddressList{get;set;} 
        
        
        public addressAD(String errorMessage, String processStatus, String ers, List<Provider_Address__c> addressList)
        {
            verifiedProvAddressList = new List<Provider_Address__c>();
            errorStatus = errorMessage;
            addressProcessStatus = processStatus;
            elementResultStatus = ers;
            if(!addressList.isEmpty()){
                for(Provider_Address__c addr : addressList){
                    verifiedProvAddressList.add(addr);
                } 
            }
        }
    }
    /*
    * @description  :   This method is to make webservice call to verify more than one address. 
    * @param        :   addressLIst
    * @return       :   List<Provider_Address__c>
    */
    public static List<Provider_Address__c> bulkAddressVerificationWebservice(List<Provider_Address__c> addressList)
    {
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        List<Provider_Address__c> providerAddressList = new List<Provider_Address__c>();
        List<Provider_Address__c> verifiedProviderAddressList = new List<Provider_Address__c>();
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
            providerAddressList = addressList.clone();
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
            req.setMethod(requestMethod);
            req.setEndpoint(endPointURL);
            req.setHeader(Label.CL536_PDI_AD_HOST, host);
            req.setHeader(Label.CL537_PDI_AD_contentType, contentType);
            req.setHeader(Label.CL538_PDI_SOAPACTION, soapAction);
            req.setHeader('Content-Length', '512'); 
            
            String reqXml =  Label.CL478_PDI_EnvelopeStart + Label.CL479_PDI_bodystart + Label.CL480_PDI_process_Start
                			+ Label.CL481_PDI_Login_Start + userName + Label.CL482_PDI_Login_End
                			+ Label.CL483_PDI_password_Start + password + Label.CL484_PDI_password_End + Label.CL485_PDI_parameters_Start
                            + Label.CL486_PDI_ProcessMode_Start + processMode +Label.CL486_PDI_ProcessMode_End + Label.CL485_PDI_parameters_End
                            + Label.CL491_PDI_Addressess_start;
            String body = '';
            for(Provider_Address__c address : addressList){
                if(address.Tech_Is_Address_Verified__c == false){
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
            }
            if(!String.isBlank(body)){
                reqXml += body;
                reqXml += Label.CL506_PDI_Addresses_End + Label.CL507_PDI_Soapbody_End;
                req.setBody(reqxml);
            }
            
            String responseXml = '';
            HttpResponse response;
            if(!Test.isRunningTest()){
                if(String.isNotBlank(body)){
                    response = ht.send(req);
                    System.debug(':::Response Code:::::'+response.getStatusCode());
                    if(response.getStatusCode() == 200){ responseXml = response.getBody(); }else{ System.debug(Label.CL565_PDI_serviceErrorMsg); }                   
                }
            }else{
                responseXml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ProcessResponse xmlns="http://validator5.AddressDoctor.com/Webservice5/v2"><ProcessResult><StatusCode>100</StatusCode><StatusMessage>OK</StatusMessage><Results><Result><ProcessStatus>C3</ProcessStatus><CountryISO3>USA</CountryISO3><ResultDataSet><ResultData><ResultNumber>1</ResultNumber><MailabilityScore>4</MailabilityScore><ResultPercentage>81.00</ResultPercentage><ElementInputStatus>40606050600000200060</ElementInputStatus><ElementResultStatus>78F0F8E0F000004000E0</ElementResultStatus><ElementRelevance>11101010100000100010</ElementRelevance><ExtElementStatus>00000000000000B00000</ExtElementStatus><AddressResolutionCode>00000000000000000000</AddressResolutionCode><AddressType>S</AddressType><LanguageISO3>ENG</LanguageISO3><Address><RecordId>'+testAddressId+'</RecordId><SubBuilding><string>APT 129</string></SubBuilding><Street><string>A ST</string></Street><HouseNumber><string>1401</string></HouseNumber><Locality><string>SACRAMENTO</string></Locality><PostalCode><string>95811-0631</string></PostalCode><Province><string>CA</string><string>SACRAMENTO</string></Province><Country><string>UNITED STATES</string></Country><DeliveryAddressLines><string>1401 A ST APT 129</string></DeliveryAddressLines><CountrySpecificLocalityLine><string>SACRAMENTO CA 95811-0631</string></CountrySpecificLocalityLine><FormattedAddress><string>1401 A ST APT 129</string><string>SACRAMENTO CA 95811-0631</string><string>UNITED STATES</string></FormattedAddress><AddressComplete>1401 A ST APT 129;SACRAMENTO CA 95811-0631;UNITED STATES</AddressComplete></Address></ResultData></ResultDataSet></Result></Results></ProcessResult></ProcessResponse></soap:Body></soap:Envelope>';
            }
            if(String.isNotBlank(responseXml)){
                List<wrapAddressAD> addressesList = new List<wrapAddressAD>();
                addressesList = parseBulkAddressResponse(responseXml);
                if(!addressesList.isEmpty() && !providerAddressList.isEmpty()){
                    for(Provider_Address__c provAddress : providerAddressList){
                        for(wrapAddressAD addr : addressesList){
                            elementResult = '';
                            if(provAddress.Id != null && (addr.addressId != null && provAddress.Id == addr.addressId)){
                                if(addr.errorMessage != null && !String.isBlank(addr.errorMessage)){
                                    System.debug('Address Status Message::::'+addr.errorMessage);
                                }else{
                                    provAddress.Id = addr.addressId;
                                    provAddress.Address_Line1__c = addr.provAddressLine1;
                                    provAddress.Address_Line_2__c = addr.provAddressLine2;
                                    provAddress.City__c = addr.provCity;
                                    provAddress.State__c = addr.provState;
                                    provAddress.Zip_Code__c = addr.provZipCode;
                                    provAddress.County__c = addr.provCounty;
                                    provAddress.Country__c = addr.provCountry;
                                    provAddress.Provider_Address_AD_Status__c = addr.addressProcessStatus;
                                    provAddress.Address_Mailability_Score__c = addr.addressScore;
                                    provAddress.Address_Result_Percentage__c = addr.addressResultPercentage;
                                    provAddress.Tech_Is_Address_Verified__c = true;
                                    
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
                                }
                            }
                            verifiedProviderAddressList.add(provAddress);
                        }
                    }
                    
                }
            }
        }catch(System.CalloutException classException){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
        return providerAddressList;
    }
    /*
    * @description  :   This method is to parse the bulk address response. 
    * @param        :   String
    * @return       :   List<wrapAddressAD>
    */
    public static List<wrapAddressAD> parseBulkAddressResponse(String respXML){
        Map<String, String> serviceStatusMap = new Map<String, String>();
        String houseNumber = '';
        String street = '';
        String building = '';
        String subBuilding = '';
        String city = '';
        String state = '';
        String postalCode = '';
        String county = '';
        String country = '';
        String processStatus = '';
        String mailabilityScore = '';
        String resultPercentage = '';
        String recordId = '';
        String resultStatus = '';
        String errorMessage = '';
        
        Dom.Document respDom = new Dom.Document();
        respDom.load(respXML);
        System.debug('respXML::::'+respXML);
        Dom.XMLNode respEnv = respDom.getRootElement();
        System.debug('respEnv::::'+respEnv);
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
                                                    }else if(licChild.getName() == Label.CL524_PDI_HouseNumber){
                                                        houseNumber = licChild.getChildElement(Label.CL533_PDI_Resp_String, Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL525_PDI_Resp_Street){
                                                        street = '' + licChild.getChildElement(Label.CL533_PDI_Resp_String,Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL527_PDI_Resp_SubBuilding){
                                                        subBuilding = licChild.getChildElement(Label.CL533_PDI_Resp_String,Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL528_PDI_Resp_Locality){
                                                        city = licChild.getChildElement(Label.CL533_PDI_Resp_String,Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL529_PDI_Resp_PostalCode){
                                                        postalCode = licChild.getChildElement(Label.CL533_PDI_Resp_String,Label.CL508_PDI_Response_Element).getText();
                                                    }else if(licChild.getName() == Label.CL530_PDI_Resp_Province){
                                                        for(Dom.XMLNode provinceChild : licChild.getChildElements()){
                                                            if(state == ''){
                                                                state = provinceChild.getText();
                                                                System.debug('::::state:::::'+state);
                                                            }else{
                                                                county = provinceChild.getText();
                                                                System.debug('::::county:::::'+county);
                                                            }
                                                        }
                                                    }else if(licChild.getName() == Label.Cl531_PDI_Resp_Country){
                                                        country = licChild.getChildElement(Label.CL533_PDI_Resp_String,Label.CL508_PDI_Response_Element).getText();
                                                    }
                                                }
                                            }
                                        }
                                    }//Result Data if Ends
                                }
                            }
                        }
                        addressADList.add(new wrapAddressAD(errorMessage, recordId, houseNumber, street, subBuilding, city, postalCode, state,
                                                            county, country, processStatus, mailabilityScore, resultPercentage, resultStatus)); 
                    }// Main if Condition
                }// Main For loop
            }// Status if condition
            else{
                if(serviceStatusMap.containsKey(statusCode)){
                    errorMessage = serviceStatusMap.get(statusCode);
                    addressADList.add(new wrapAddressAD(errorMessage, recordId, houseNumber, street, subBuilding, city, postalCode, state,
                                                            county, country, processStatus, mailabilityScore, resultPercentage, resultStatus));
                }
            }
        }catch(Exception classException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.CL367_PDI_errorMsg));
            Utility.handleExceptionFromCode(classException.getMessage() + Label.CL218_rSlashN + classException.getStackTraceString() + Label.CL218_rSlashN + classException.getTypeName() + Label.CL218_rSlashN + System.now() + Label.CL218_rSlashN + Label.CL564_PDI_Hyphens);
        }
        return addressADList;
    }
    
    /**  
    *    Description : Address Wrapper Class.
    */
    public class wrapAddressAD{
        public Boolean selected {get; set;}
        public String provAddressLine1{get;set;}
        public String provAddressLine2{get;set;}
        public String provCity{get;set;}
        public String provState{get;set;}
        public String provZipCode{get;set;}
        public String provCounty{get;set;}
        public String provCountry{get;set;}
        public String addressProcessStatus{get;set;}
        public String addressScore{get;set;}
        public String addressResultPercentage{get;set;}
        public String addressElementResultStatus{get;set;}
        public String addressId{get;set;}
        public String errorMessage{get;set;}
        public wrapAddressAD(String errorMsg, String recordId, String houseNumber, String street, String subBuilding, String city, 
                             String postalCode, String state, String county, String country,
                             String processStatus, String mailabilityScore, String resultPercentage, String resultStatus)
        {
            errorMessage = errorMsg;
            addressId = recordId;
            provAddressLine1 = houseNumber + ' '+ street;
            provAddressLine2 = subBuilding;
            provCity = city;
            provState = state;
            provZipCode = postalCode;
            provCounty = county;
            provCountry = country;
            selected = false;
            addressProcessStatus = processStatus;
            addressScore = mailabilityScore;
            addressResultPercentage = resultPercentage;
            addressElementResultStatus = resultStatus;
        }
    }
    
}