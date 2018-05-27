/**  
*    Class Name: GoogleAnalytics
*    Author: Offshore Team
*    Date: 14-August-2014
*    Description: Main Class for creating Login Request through HTTP request to Google Analytics.
*  
*    --------
**/
public with sharing class GoogleAnalytics {
    public static final string LoginUrl = 'https://www.google.com/accounts/ClientLogin';
    public static final integer LagDays = 2;
    
    /* number of entries returned in trending mock data */
    public static final integer MockTrendEntries = 2; 

    public static final string PageViewsPerVisitMetric = 'ga:pageviewsPerVisit';
    public static final string VisitorsMetric = 'ga:visitors';
    public static final string PercentNewVisitsMetric = 'ga:percentNewVisits';
    public static final string VisitBounceRateMetric = 'ga:visitBounceRate';
    public static final string AverageTimeOnSiteMetric = 'ga:avgTimeOnSite';
    public static final string SessionMetric = 'ga:sessions';

    public static final string DateDimension = 'ga:date';
    public static final string NthWeekDimension = 'ga:nthWeek';
    public static final string CustomVariableValue1Dimension = 'ga:customVarValue1';    
    public static final string CustomVariableValue2Dimension = 'ga:customVarValue2';    
    public static final string CustomDimension1 = 'ga:dimension1';   //added by pulkit
    public static final string CustomDimension2 = 'ga:dimension2';   //on 30 Sep 
    public static final string CustomDimension3 = 'ga:dimension3';    // to fetch custom dimensions
    public static final string BrowserDimension = 'ga:browser';
    public static final string DayOfWeekDimension = 'ga:dayofWeekName';

    public static final String TotalEventsMetric = 'ga:totalEvents';
    public static final String UniqueEventsMetric = 'ga:uniqueEvents';
    public static final String EventCategoryDimension = 'ga:eventCategory';
    public static final String EventActionDimension = 'ga:eventAction';
    public static final String EventLabelDimension = 'ga:eventLabel';

    public static final string FilterAnd = ';'; 
    public static final string FilterOr = ',';
    
    /* these use non-standard URL encoding */
    public static final string FilterNotEqual = '!%3D'; 
    public static final string FilterEqual = '%3D%3D';
    public static final string FilterMatchRegex = '%3D~';
        
    public static final decimal TestValue = 1;
    public static final string NotSetValue = '(not%20set)';
    public static final string Missing = 'MISSING';
    
    //specify callout expire time
    private static integer expiresIn = 0;
    /* specifiy mock values for specific dimensions */
    public static map<string, string> mockDimensionValue = new map<string, string>();
    
    static final map<string, string> metricName = new map<string, string>{
        VisitorsMetric => 'Visitors',
        PageViewsPerVisitMetric => 'Page Views Per Visit',
        PercentNewVisitsMetric => 'New Visit Percent',
        VisitBounceRateMetric => 'Bounce Rate',
        AverageTimeOnSiteMetric => 'Average Time on Site',
        CustomDimension1=> 'User Region',
        TotalEventsMetric=>'Events'
    };
    /* Public Method for creating the Maps of Dimension and Metric */
    public class Entry {
        public map<string, string> dimensions { get; private set; }
        public map<string, string> metrics { get; private set;}
        
        public Entry() {
            this.dimensions = new map<string, string>();
            this.metrics = new map<string, string>();
        }
       /* Public Method for setting the Dimension */ 
        public void setDimension(string name, string value) {
            dimensions.put(name, value);
        }
       /* Public Method for getting the Dimension */ 
        public string getDimension(string name) {
            return dimensions.get(name);
        }
        /* Public Method for setting the Metric */ 
        public void setMetric(string name, string value) {
            metrics.put(name, value);
        }
        /* Public Method for getting the Metric */ 
        public string getMetric(string name) {
            return metrics.get(name);
        }
        
        public void invertMetric(string name, string inverseName) {
            setMetric(inverseName, string.ValueOf(100 - decimal.ValueOf(getMetric(name))));
        }
    }
    /* Public Methods for defining email,password and tableID */
    public string email { get; set; }
    public string password { get; set; }
    public string tableId { get; set; }
    
    //specify GA OAuth Token
    private static string Oauthtoken = '';
    private static Site_Metric_Settings__c setting = new Site_Metric_Settings__c();
    
    /* Public Method for initializing the Email,Password and TableId from Site Metric Custom Setting*/
    public GoogleAnalytics(Site_Metric_Settings__c settings) {
        initialize(settings.Email__c, settings.Password__c, settings.Table_Id__c);
        setting = settings;
        Oauthtoken = RetreiveAccessToken();
    }
    
    /* Public Method for initializing the Email,Password and TableId */
    public GoogleAnalytics(string email, string password, string tableId) {
        initialize(email, password, tableId);
    }
    /*for initializing login*/
    private void initialize(string email, string password, string tableId) {
        this.email = email;
        this.password = password;
        this.tableId = tableId;
    }
    
    /*creates mock entries for test class*/
    list<Entry> createMockEntries(Date startDate, Date endDate, list<string> dimensions, list<string> metrics) {
        System.debug('createMockEntries for ' + startDate + ' ' + endDate + ' ' + dimensions + ' ' + metrics);
        Entry entry = createMockEntryWithTestValues(dimensions, metrics);
        list<Entry> entries = new list<Entry>{ entry };
        
        if (dimensions != null) {
            set<string> dimensionSet = new set<string>();
            dimensionSet.addAll(dimensions);
            
            if (dimensionSet.contains(CustomVariableValue1Dimension)) {
                Entry notSetEntry = createMockEntryWithTestValues(dimensions, metrics);
                notSetEntry.setDimension(CustomVariableValue1Dimension, NotSetValue);
                System.debug('adding notSetEntry for CustomVariableValue1Dimension');
                entries.add(notSetEntry);               
            }

            if (dimensionSet.contains(DateDimension)) {
                System.debug('Adding data for dates ' + startDate + ' to ' + endDate);
                for (Date d=startDate; d <= endDate; d = d.addDays(1)) {
                    System.debug('adding additional trend/date entry for ' + d);
                    /* add entries for trend data  */
                    entries.add(entry); 
                }   
            }
        }
        
        System.debug('Getting test entries ' + entries);
        
        return entries;     
    }
    /*Creates mock entriee for test class*/
    Entry createMockEntryWithTestValues(list<string> dimensions, list<string> metrics) {
        Entry entry = new Entry();
        
        for (string metric : metrics) {
            entry.setMetric(metric, string.valueOf(TestValue));
        }
        
        if (dimensions != null) {
            for (string dimension : dimensions) {
                string value;
                if (dimension == DateDimension) {
                    value = '20110101';
                } else if (mockDimensionValue.containsKey(dimension)) {
                    value = mockDimensionValue.get(dimension);
                } else {
                    value = string.valueOf(TestValue);
                }
                entry.setDimension(dimension, value);
            }
        }
        
        return entry;       
    }
    /*to format date*/
    public static string formatDate(Date d) {
        Datetime dt = Datetime.newInstance(d, Time.newInstance(0,0,0,0));
        return dt.format('yyyy-MM-dd');
    }
    /*get the metric value by sending a string*/
    public static string getMetricName(string metric) {
        return metricName.get(metric);
    }
    /*Join two strings by a delimiter*/
    public static String join(List<string> items, string delimiter) {
        string s = '';
        integer i = 0;
    
        for (string item : items) {
            if (i++ > 0) { 
                s += delimiter; 
            }
            s += item;
        }
    
        return s;
    }
    /*two days before days*/
    public static Date lastAvailableDate() {
        return Date.today()-lagDays;
    }
    
    //Retreive Access token Through Google OAuth(Kamendra Singh)
    public static string RetreiveAccessToken(){
       string accessToken = '';
        http h = new Http();
        Httprequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        string endPointValue = setting.EndPointValue__c;
        
        req.setEndpoint(endPointValue);
        req.setMethod(setting.Method__c);
       
        req.setHeader(setting.ContentType__c,setting.ContentTypeValue__c);
       
        String Header = setting.Header__c;
        String Header_Encode = EncodingUtil.base64Encode(blob.valueof(Header));
       
        String claim_set = setting.claim_set_iss__c;
       
        claim_set += setting.claim_set_scope__c; 
        claim_set += setting.claim_set_aud__c; 
        claim_set += setting.claim_set_exp__c+datetime.now().addHours(1).getTime()/1000; 
        claim_set += setting.claim_set_iat__c+datetime.now().getTime()/1000+'"}'; 
       
       
       
        String claim_set_Encode = EncodingUtil.base64Encode(blob.valueof(claim_set));
       
        String Singature_Encode = Header_Encode+'.'+claim_set_Encode;
     
        String key = setting.Private_key1__c;
        key += setting.Private_key2__c;
        key += setting.Private_key3__c;
        key += setting.Private_key4__c;
        key += setting.Private_key5__c;
        key += setting.Private_key6__c;
        key += setting.Private_key7__c;
        system.debug('key++++'+key);
        
        blob privateKey = EncodingUtil.base64Decode(Key);
        system.debug('privateKey+++'+privateKey);
        Singature_Encode = Singature_Encode.replaceAll('=','');
        String Singature_Encode_Url = EncodingUtil.urlEncode(Singature_Encode,'UTF-8');
        blob Signature_b =   blob.valueof(Singature_Encode_Url);
       
        String Sinatute_blob = base64(Crypto.sign(setting.RSA_Value__c, Signature_b , privateKey));
              
        String JWT = Singature_Encode+'.'+Sinatute_blob;
       
        JWT = JWT.replaceAll('=','');
       
             
        String grt = setting.grant_typeValue__c;
        req.setBody('grant_type='+grt+'&assertion='+JWT);
        if (!Test.isRunningTest()){ 
        res = h.send(req);
        }
        string Response = res.getBody() +' '+ res.getStatusCode();
        system.debug('Response====='+Response );
        
        map<string, string> jsonValues = new map<string, string>();
        jsonValues = parseJSONToMap(res.getBody());
        if(jsonValues.containsKey('error')){
            //Just some debug lines to see the request and response
            string valuetoShow = 'Get Access Token Error: ' + res.getBody() + ' end point value: ' + endPointValue + 'request: ' +
                req.toString() + 'request headers: ' + req.getHeader('Content-Type') + '; ' + req.getHeader('charset') + 
                'request body: ' + req.getBody();           
        }else{
            //Try to get a cell value in the Google Spreadsheet
            accessToken = jsonValues.get('access_token');
            string refreshToken = jsonValues.get('refresh_token');
            if(jsonValues.get('expires_in') != null){
            expiresIn = Integer.valueof(jsonValues.get('expires_in'));
            }
        } 
        return accessToken;
    }
     private static String base64(Blob b) {
        String ret = EncodingUtil.base64Encode(b);
        ret = ret.replaceAll('\\+', '-');
        ret = ret.replaceAll('/', '_');
        ret = ret.replaceAll('=', '');
        return ret;
    }
    
    //SECTION START: Below here is all the code to parse JSON.
    private static map<string, string> parseJSONToMap(string JSONValue){
        JSONParser parser = JSON.createParser(JSONValue);
        map<string, string> jsonMap = new map<string, string>();
        string keyValue = '';
        string tempValue = '';
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                keyValue = parser.getText();
                parser.nextToken();
                tempValue = parser.getText();
                jsonMap.put(keyValue, tempValue);               
            }
        }
        return jsonMap;
    }
    
    //Parse the retreived entries
    public static list<Entry> parseEntries(string xml) {
        System.debug('Response: ' + xml);   
        Dom.document doc = new Dom.Document();
        doc.load(xml);
        
        list<Entry> entries = new list<Entry>();
        
        for (Dom.Xmlnode entryNode : doc.getRootElement().getChildElements()) {

            
            if (entryNode.getName() == 'entry') {
                Entry entry = new Entry();
                
                for (Dom.Xmlnode node : entryNode.getChildElements()) {
                    string name = node.getAttributeValue('name','');
                    string value = node.getAttributeValue('value','');
                    
               

                    if (node.getName() == 'dimension') {
                        entry.setDimension(name, value);
                    } else if (node.getName() == 'metric') {
                        entry.setMetric(name, value);
                    }
                }
                
                entries.add(entry);
                //System.debug('\n');
            }
        }
        
        return entries;
    }
    // to parse the returned login token
    public static string parseAuthToken(string loginResponse) {
     
    /* split so we get 'Auth=TOKEN'  */
        system.debug('@@loginResponse : ' + loginResponse);
        return loginResponse.split('\\n')[2];
    }
    /* Creates a login request*/
    public static HttpRequest createRequest(string token, Date startDate, Date endDate, list<string> dimensions, list<string> metrics, string filter, string id, integer maxResults, integer startIndex) {
        if (dimensions == null) {
            dimensions = new list<string>();
        }
        if (filter == null) {
            filter = '';
        }
        
        HttpRequest req = new HttpRequest();
        
        string endpoint = setting.EndPoint__c +
            '?start-date=' + GoogleAnalytics.formatDate(startDate) + 
            '&end-date=' + GoogleAnalytics.formatDate(endDate) +
            '&dimensions=' + join(dimensions, ',') + 
            '&metrics=' + join(metrics, ',') + 
            //'&filters=' + filter + 
            '&prettyprint=true' +
            '&ids=' + id
            ;
        if (maxResults != null) {
            endpoint += '&max-results=' + maxResults;
        }
        if (startIndex != null) {
            endpoint += '&start-index=' + startIndex;
        }
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        system.debug('expiresIn+++++!!!'+expiresIn);
        if(expiresIn != 0){
        req.setTimeout(expiresIn);
        }
        //req.setTimeout(300);
        req.setHeader('GData-Version', '2');
        
        System.debug('Request: ' + req.getEndpoint());
        return req;

    }
    /*Calls the getEntries method*/
    public Entry getEntry(Date startDate, Date endDate, list<string> dimensions, list<string> metrics, string filter) {
        return getEntries(startDate, endDate, dimensions, metrics, filter)[0];
    }
    //Calls the getEntries method with null filter
    public list<Entry> getEntries(Date startDate, Date endDate, list<string> dimensions, list<string> metrics) {
        return getEntries(startDate, endDate, dimensions, metrics, null);
    }
    /*Calls the getEntries method with null filter*/
    public list<Entry> getEntries(Date startDate, Date endDate, list<string> dimensions, list<string> metrics, string filter) {
        return getEntries(startDate, endDate, dimensions, metrics, filter, null, null);
    }
    /*sends  the request to Google Analytics server and parses the response*/
    public list<Entry> getEntries(Date startDate, Date endDate, list<string> dimensions, list<string> metrics, string filter, integer maxResults, integer startIndex) {
        if (Test.isRunningTest()) {
           return createMockEntries(startDate, endDate, dimensions, metrics);
        } else 
        {
            return parseEntries(send(createRequest(Oauthtoken, startDate, endDate, dimensions, metrics, filter, tableId, maxResults, startIndex)).getBody());
        }
    }
    



     /*parses the date data */
    public static Date parseDate(string dt) {           
        if(dt != null && dt.length() == 8){
            return Date.newInstance(
                                        Integer.valueOf(dt.substring(0,4)), 
                                        Integer.valueOf(dt.substring(4,6)),
                                        Integer.valueOf(dt.substring(6,8))
                                    );
        } else {
            throw new GoogleAnalyticsException('Invalid date: ' + dt);
        }
    }
    
    /*Main class to send the Http response*/
    public static HttpResponse send(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        try{
        Http h = new Http();    
        //if (!Test.isRunningTest()){ 
        response = h.send(req);
        //} 
        if (response.getStatusCode() != 200) {
            throw new GoogleAnalyticsException('Request Error: ' + response.getBody());
        }
        system.debug('======='+response.getBody());
        return response;
        }
        catch(System.CalloutException ex){
            system.debug('Expire++'+ex+'=====responce'+response);
            HttpResponse Htresponse = new HttpResponse();
            Htresponse = RefreshToken(req);
            return Htresponse;
        }
    }
    
    //refresh_token after timed out
    public static HttpResponse RefreshToken(HttpRequest req){
        Oauthtoken = '';
        Oauthtoken = RetreiveAccessToken();
        
        HttpResponse response = new HttpResponse();
        Http h = new Http();
        req.setHeader('Authorization', 'Bearer ' + Oauthtoken);
        //if (!Test.isRunningTest()){ 
        response = h.send(req);
        //}
            
        if (response.getStatusCode() != 200) {
            throw new GoogleAnalyticsException('Request Error: ' + response.getBody());
        }
        system.debug('======='+response.getBody());
        return response;
        
    }
    
    /*Exception handler*/
    public class GoogleAnalyticsException extends Exception {}
}