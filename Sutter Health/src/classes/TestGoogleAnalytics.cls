@isTest
                                
private class TestGoogleAnalytics {

   // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';
   
    /**
    * @author IDC Team
    * @date 05/10/2015
    * @description This method create test data.
    * @param 
    * @return void
    */
     @testSetup 
     static void createTestData() {
        //@description This method create test data for Site_Metric_Settings custom setting.
        Site_Metric_Settings__c settings = new Site_Metric_Settings__c();
        settings.Name ='Google Analytics';
        settings.Email__c='sutterhealthportal@gmail.com';
        settings.Table_Id__c='ga:84425846';
        settings.Track_Sessions__c=true;
        settings.Tracking_Sessions__c=false;
        settings.Track_Events__c=true;
        settings.Tracking_Events__c=false;
        settings.password__c='sh@123456';
        settings.claim_set_aud__c = ',"aud":"https://accounts.google.com/o/oauth2/token"';
        settings.claim_set_exp__c = ',"exp":"';
        settings.claim_set_iat__c = '","iat":"';
        settings.claim_set_iss__c = '{"iss":"933629996729-t4stb0a7ufvfklu31k8d5gjqvavnavhi@developer.gserviceaccount.com"';
        settings.claim_set_scope__c = ',"scope":"https://www.googleapis.com/auth/analytics"';
        settings.ContentType__c = 'ContentType';
        settings.ContentTypeValue__c = 'application/x-www-form-urlencoded';
        settings.End_Date__c = system.today();
        settings.EndPoint__c = 'https://www.googleapis.com/analytics/v2.4/data';
        settings.EndPointValue__c = 'https://accounts.google.com/o/oauth2/token';
        settings.grant_typeValue__c = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        settings.Header__c = '{"alg":"RS256","typ":"JWT"}';
        settings.Method__c = 'POST';
        settings.Private_key1__c = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCodlEbsjNQ0pAjHIAZmu7dclv6dQ96TFfyG++74k/HkJzr9fIXBKzU4Gc12XpNfW9SejUypl8IaUFfIMGy4zm8GNPTXeSvrvRkfAt1HIgW2i+mSAkiCMVZw3E6e0sm5PSxqzk6Pqy90JSoIvU6GVstdE2nRJtqEcHOejAUKxxCN+R0dRbOsS9dbe1Lc08/chhYW2itlI+jOHx';
        settings.Private_key2__c = 'ogYOxU39pEyLlxCkTNxh/Q1nmjMlf5pHiiHRZFygJ/FQfux5FZyLTQTZJ3TEgzoNiRrjU8HHcPknwnwGumV/dHJXiLrEAuKbl7//dc5towFzCCI0G63SajElv/X/3XL2lIDEnCJmzAgMBAAECggEBAIS9dfuU1sqAoAKKmoWSh1UGn2MiiiebsFCdorExChv93ygui6uHi4fRqoHL84rLo8Qhd3mJjqhaB6Cldvs2AHAuP/r0qRWljfz/oSeOa8';
        settings.Private_key3__c = '1V7uXfLRMcRiUM01N5gyYKkqTMfjNe305R5FD3+rLk9+tBEU8TyEIz67p+nRPHRGUHzj5WHa+nCOs7eRia6OYEh7kMmTLGNGgtWiJ7cDgg5vLoaKBlYdLQOCj9259iTODjPhMoJArmiCpVbGw+UdN/DXMMG4LFk+FZI1ezkhMagLqpMtVy7zsgNyHs2iT7kV/EiKKn+L5JVPhj1IyTg1UQZeZRMy6VMtZVrEGL+AabQ4ECgYEA0AiPou+XXU47c ';
        settings.Private_key4__c = 'pFJWPJLGs4eeQmyoAtVu1ZdVAtb0Xcsq/EkL/o981XvfoWu5oFfhhVkfCZ2FGPbzOjCwyKgumHi3qgHBcwss1BoSsNy+zrVNTE/iu3fl8JYv6bsNIVrC1NNwTFLlQLfKHAWEZMzU6+zsGkDPBrIIh0YDXfkWCkCgYEAz04C5kJ2nsTQf/EmvgU5Kl3q1JiA2rNwrtQWNnO2uOlgcFQYK0P0IiQug8jxVnW/U9635vh54NdbJo6ac9/JTGS1o6oU';
        settings.Private_key5__c = 'j1ET2WzaN59yf5uIBxJkAGE6qazjqbmLvrIphA8UzacHr8YWwmq73ztOLylQUka/Z2D11sk6+YOADnsCgYB0dVZzkEzcHv+Ik2zMLld9GgZVG+izT6UeyqpUckdka6LGXqgzc5NatbDs00mmIKapGTC3j5BqubxCacseEjSIImQu4UGNLU+Y0lqP//pOShExRfCcha2190ZXg8qXXFkgbfIJRN9a+9CRgq3YCN+i6aleCGuXKib/ceoVIBjkgQK';
        settings.Private_key6__c = 'BgQCr59sLqo3HNxpXHlisNpSjB2KWjSg9M5P7xi/tU6NwT0cDnxizuBQYw7w22EkZE2dnW0dRJzeaNbuGi7aU5Dx/NvxRDdciyW8WW+fRPE2seAMjKiL3FamZzp6zvgOeTQuUURVFPH9pSXDSI8RLZ1h8T1wl/jj2tzblt9VJ17w3RQKBgQCswMvM+9a+aJp+9zDo7Cr+Ygh5UNBY5DeeGjpgi+oYjzwqRz513VxNhqWNjWUZ+qclVHHVnVQJsR';
        settings.Private_key7__c = 'LXPpB2YfsxCiks1rbZMvlbskvOkI3UPwzoZojV2LaBOYWCqpBHwFosuYb7QwavLBRriBlL++fJ0zxNhApARl116a9LeghELQu003du003d';
        settings.RSA_Value__c = 'RSA-SHA256';
        settings.Start_Date__c = system.today();

        insert settings;
        //Assert to check custom setting data is created successfully
        system.assert(settings.id!=null);
    }
    static testmethod void testGAMain(){
    Site_Metric_Settings__c TempSMSetting = Site_Metric_Settings__c.getValues('Google Analytics');
    Test.startTest();
    GoogleAnalytics ganalytics = new GoogleAnalytics('test@test.com','sh@123456','ga:84425846');
    GoogleAnalytics objGA = new GoogleAnalytics(TempSMSetting);
    string token = GoogleAnalytics.RetreiveAccessToken();
    String dat = GoogleAnalytics.formatDate(System.Today());
    List<String> stlist = new List<String>{'abc','123'};
    GoogleAnalytics.join(stlist,':');
    Date dte = GoogleAnalytics.lastAvailableDate();
    string authToken = 'Auth=EQABDJADAC1ikInXJYXCTND1zxdkz__RSYAs4Ld4H-zAGou6b9GA1fi3abzgfbWZ-f5KqmL6uSb3ihGQhv3Ettedi_MIRg-piRfbVIWraidqUAm0IhiinSy5b31E88if58jCv-yTiHT1onByjEFPVq7KxU7KX-QTeZ8X57KTKhzJkzEXw90Q'; 
    string loginResponse = 'SID=DQAAAH8AABA0K-4yEMQfEkXQQcB0wpZ_H8XEMsWoDdTN82Fb92tWE2eQ71N0KPJA3tC-XFryuvgiGDqyVEA4-kAngTCHfpD2rbZ8jZC8u_N5vecgznyGUyGGhVZJDkG-tyZ-AeGjn0qnbwsr6MwjFaSppwBCpMjcw9rtE-YrjtmlYrrFiWndtA\n' +      'LSID=DQAAAIIAAAC1ikjaInXJYXCTND1zxdkz__RSYAp4Ld4H-yAGou6b8QZ7fi4rzgebTZ-f5KqmL7s2KYNOqC9mG3AzcSAdVNkDkg6Nry2i4lO69iIgDLya8tLdvBluIfjsEXEVczWSjo6cda3Xib5P2y1WuyVsSC92OrajFqTe9sGR7_w8DtCTICcNhgrjjXzYXdiJatzfCz0\n' +      authToken;  
    System.assertEquals(authToken, GoogleAnalytics.parseAuthToken(loginResponse));
    list<string> dimensions = new list<string>{'ga:customVarValue1','ga:date'};
    list<string> metrics = new list<string>{'ga:sessions'};
    Date dt = GoogleAnalytics.parseDate('20140022');
    string entriesXml = '<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2009/Atom" xmlns:dxp="http://schemas.google.com/analytics/2009" xmlns:openSearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:gd="http://schemas.google.com/g/2009" gd:etag="W/&quot;BEANSHcycSp7I2A9Wx9VEUo.&quot;" gd:kind="analytics#data"><id>http://www.google.com/analytics/feeds/data?ids=ga:422526&amp;dimensions=ga:date,ga:browser&amp;metrics=ga:sessions&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-27T15:59:59.999-08:00</updated><title>Google Analytics Data for Profile 41510670</title><link rel="self" type="application/atom+xml" href="https://www.google.com/analytics/feeds/data?max-results=10&amp;sort=-ga%3Apageviews&amp;end-date=2011-01-27&amp;start-date=2011-01-01&amp;metrics=ga%3Apageviews&amp;ids=ga%3A41510670&amp;dimensions=ga%3ApageTitle%2Cga%3ApagePath"/><author><name>Google Analytics</name></author><generator version="1.0">Google Analytics</generator><openSearch:totalResults>10</openSearch:totalResults><openSearch:startIndex>1</openSearch:startIndex><openSearch:itemsPerPage>10</openSearch:itemsPerPage><dxp:aggregates><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="17"/></dxp:aggregates><dxp:containsSampledData>false</dxp:containsSampledData><dxp:dataSource><dxp:property name="ga:profileId" value="41510670"/><dxp:property name="ga:webPropertyId" value="UA-20974577-1"/><dxp:property name="ga:accountName" value="Test1"/><dxp:tableId>ga:212120</dxp:tableId><dxp:tableName>cs10.force.com/</dxp:tableName></dxp:dataSource><dxp:endDate>2014-11-2</dxp:endDate><dxp:startDate>2013-01-01</dxp:startDate><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:1234456&amp;ga:pagePath=/hcpHome&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Home&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Home &#124; ga:pagePath=/hcpHome</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Home"/><dxp:dimension name="ga:pagePath" value="/hcpHome"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="6"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Home&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Home &#124; ga:pagePath=/</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Home"/><dxp:dimension name="ga:pagePath" value="/"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="2"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpMedicalRequest&amp;ga:pageTitle=Sunovion%20ProFile&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile &#124; ga:pagePath=/hcpMedicalRequest</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile"/><dxp:dimension name="ga:pagePath" value="/hcpMedicalRequest"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpDosing&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Dosing%20Information&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Dosing Information &#124; ga:pagePath=/hcpDosing</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Dosing Information"/><dxp:dimension name="ga:pagePath" value="/hcpDosing"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/apex/hcphome&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Home&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Home &#124; ga:pagePath=/apex/hcphome</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Home"/><dxp:dimension name="ga:pagePath" value="/apex/hcphome"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpMedicalRequest&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Medical%20Inquiry&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Medical Inquiry &#124; ga:pagePath=/hcpMedicalRequest</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Medical Inquiry"/><dxp:dimension name="ga:pagePath" value="/hcpMedicalRequest"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpPatientGuides&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Medication%20Guides&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Medication Guides &#124; ga:pagePath=/hcpPatientGuides</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Medication Guides"/><dxp:dimension name="ga:pagePath" value="/hcpPatientGuides"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpPI&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Prescribing%20Information&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Prescribing Information &#124; ga:pagePath=/hcpPI</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Prescribing Information"/><dxp:dimension name="ga:pagePath" value="/hcpPI"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpRequestSamples&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Request%20Samples&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Request Samples &#124; ga:pagePath=/hcpRequestSamples</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Request Samples"/><dxp:dimension name="ga:pagePath" value="/hcpRequestSamples"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry><entry gd:etag="W/&quot;DEMEQX47eSp7I2A9Wx9VEEU.&quot;" gd:kind="analytics#datarow"><id>http://www.google.com/analytics/feeds/data?ids=ga:41510670&amp;ga:pagePath=/hcpRequestSamples?voucher%3D1&amp;ga:pageTitle=Sunovion%20ProFile%20-%20Request%20Savings&amp;start-date=2011-01-01&amp;end-date=2011-01-27</id><updated>2011-01-26T16:00:00.001-08:00</updated><title>ga:pageTitle=Sunovion ProFile - Request Savings &#124; ga:pagePath=/hcpRequestSamples?voucher=1</title><link rel="alternate" type="text/html" href="http://www.google.com/analytics"/><dxp:dimension name="ga:pageTitle" value="Sunovion ProFile - Request Savings"/><dxp:dimension name="ga:pagePath" value="/hcpRequestSamples?voucher=1"/><dxp:metric confidenceInterval="0.0" name="ga:pageviews" type="integer" value="1"/></entry></feed>';
    list<GoogleAnalytics.Entry> entries = GoogleAnalytics.parseEntries(entriesXml); 
    System.assertEquals('/hcpHome', entries[0].getDimension('ga:pagePath'));  
    System.assertEquals('6', entries[0].getMetric('ga:pageviews'));
    string metr = GoogleAnalytics.getMetricName('Events');
    //  String met = ganalytics.getMetric('ga:date');
    GoogleAnalytics.Entry ent1= ganalytics.getEntry(System.Today(),System.Today(),dimensions,Metrics,null);
    Test.stopTest();

    }
    
    static testmethod void testImportEvent() {
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new GoogleAnalyticsImporterEvent());
         
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
        ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', 
        String.valueOf(ct.NextFireTime));

        Test.stopTest();
   }
   
    static testmethod void testImportSession() {
    Test.startTest();

    // Schedule the test job
    String jobId = System.schedule('ScheduleApexClassTest',
                    CRON_EXP, 
                    new GoogleAnalyticsImporterSession());
     
    // Get the information from the CronTrigger API object
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
     NextFireTime
     FROM CronTrigger WHERE id = :jobId];

    // Verify the expressions are the same
    System.assertEquals(CRON_EXP, 
     ct.CronExpression);

    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);

    // Verify the next time the job will run
    System.assertEquals('2022-03-15 00:00:00', 
     String.valueOf(ct.NextFireTime));

    Test.stopTest();
    }
    
    @isTest static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        GoogleAnalytics ganalytics = new GoogleAnalytics('test@test.com','sh@123456','ga:84425846');
        Site_Metric_Settings__c TempSMSetting = Site_Metric_Settings__c.getValues('Google Analytics');
        GoogleAnalytics objGA = new GoogleAnalytics(TempSMSetting);
        Date dte = GoogleAnalytics.lastAvailableDate();
        
        string authToken = 'Auth=EQABDJADAC1ikInXJYXCTND1zxdkz__RSYAs4Ld4H-zAGou6b9GA1fi3abzgfbWZ-f5KqmL6uSb3ihGQhv3Ettedi_MIRg-piRfbVIWraidqUAm0IhiinSy5b31E88if58jCv-yTiHT1onByjEFPVq7KxU7KX-QTeZ8X57KTKhzJkzEXw90Q'; 
        list<string> dimensions = new list<string>{'ga:dimension2','ga:date'};
        list<string> metrics = new list<string>{'ga:sessions'};
        HttpRequest req2 = GoogleAnalytics.createRequest('authtoken', dte, dte, null, metrics, null, 'ga:84425846', 1, 1);
        Test.startTest();
        HttpResponse Response1 = GoogleAnalytics.send(req2);
        HttpResponse Response2 = GoogleAnalytics.RefreshToken(req2);
        Test.stopTest();
        // Verify response received contains fake values
        String contentType = Response1.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = Response1.getBody();
        String expectedValue = '{"access_token":"oxgfsd4231656"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, Response1.getStatusCode());
    }
    
}