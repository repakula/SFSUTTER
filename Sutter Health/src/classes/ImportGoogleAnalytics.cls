/**  
*    Class Name: ImportGoogleAnalytics
*    Author: Offshore Team
*    Date: 14-August-2014
*    Description: This is a class where we are importing the data of Events and DailyMetrics.
*    History
*    --------
**/
public with sharing class ImportGoogleAnalytics {
    public static GoogleAnalytics ga;
    public static string singleMetricName = 'Test Single Metric';
    Public list<Site_Event__c> events = new list<Site_Event__c>();

    /*The 2 methods are not required currently but maybe handy in future to  fetch data for these metrics
    public static void importSingleMetric(string siteMetricSettingsName) {
        if(initialize(siteMetricSettingsName)) {    
            
            Site_Metric_Date__c metricDate = new Site_Metric_Date__c(Name = '2011 Q1', Start_Date__c = Date.newInstance(2011,1,1), 
                End_Date__c = Date.newInstance(2011,3,31));
                
            GoogleAnalytics.Entry entry = ga.getEntry(metricDate, new list<String>{GoogleAnalytics.VisitorsMetric});
            
            // only start inserts after all callouts are complete       
            insert metricDate;
            
            Site_Metric__c metric = new Site_Metric__c(Name = singleMetricName, Metric__c = GoogleAnalytics.VisitorsMetric, 
                Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.VisitorsMetric)), Site_Metric_Date__c = metricDate.Id);              
                
            insert metric;
        }       
    }
    
    public static void importDailyMetrics(string siteMetricSettingsName) {
        if(initialize(siteMetricSettingsName)) {        
            Date startDate = Date.newInstance(2014, 8, 14);
            Date endDate = Date.newInstance(2014, 8, 14);
        
            ga.insertDailyMetrics(startDate, endDate, new list<String>{GoogleAnalytics.VisitorsMetric,
                                        GoogleAnalytics.PageViewsPerVisitMetric,
                                        GoogleAnalytics.PercentNewVisitsMetric,
                                        GoogleAnalytics.VisitBounceRateMetric,
                                        GoogleAnalytics.AverageTimeOnSiteMetric});
        }
    }
    
    */
    
    @future(callout=true)
    public static void callEventMethods(boolean TodayData)
    { 
       
       //Public list<Site_Event__c> events = new list<Site_Event__c>();

       importEvents(System.Label.CL52_Google_Analytics,TodayData);
       //importUniqueEvents(System.Label.CL52_Google_Analytics,TodayData);

    } 
     
     @future(callout=true)
     public static void callSessionMethods(boolean TodayData)
    { 
       importSessions1(System.Label.CL52_Google_Analytics,TodayData);
                 } 

       
    
    //Class to Import all the events
    public static void importEvents(string siteMetricSettingsName,boolean TodaysData) {
        if(initialize(siteMetricSettingsName)) {        
                      Site_Metric_Settings__c settings;
                      Date startDate ;
                      Date endDate;
            If (TodaysData == true) // If we want to fetch only todays data 
            {startdate = (System.Today()).adddays(-1);endDate = (System.Today()).adddays(-1);}        
            else{// we fetch the data since google analytics was implemented
            //startdate = Date.newInstance(2014,10,17);
            settings = [Select s.Start_Date__c,s.End_Date__c,s.Table_Id__c, s.Password__c, s.Email__c From Site_Metric_Settings__c s where s.Name = :siteMetricSettingsName];
            startDate = settings.Start_Date__c;
            endDate = settings.End_Date__c;
            }
            //Date endDate = (System.Today()).adddays(-1);
            List<String> metrics = new List<String>{GoogleAnalytics.TotalEventsMetric};         
            List<String> dimensions = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.EventCategoryDimension, 
                GoogleAnalytics.EventActionDimension};
        
            list<GoogleAnalytics.Entry> entries = ga.getEntries(startDate, endDate, dimensions, metrics);
            list<Site_Event__c> events = new list<Site_Event__c>();
            
            for (GoogleAnalytics.Entry entry : entries) {
                Site_Event__c event = new Site_Event__c(
                    Name = 'Event',
                    Category__c = entry.getDimension(GoogleAnalytics.EventCategoryDimension),
                    Action__c = entry.getDimension(GoogleAnalytics.EventActionDimension),
                    Count__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.TotalEventsMetric)),
                    Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)),
                    Metric_Name__c = 'All Events');
                events.add(event);
            }
             List<String> metrics1 = new List<String>{GoogleAnalytics.UniqueEventsMetric};         
            List<String> dimensions1 = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.EventCategoryDimension, 
                GoogleAnalytics.EventActionDimension};
        
            list<GoogleAnalytics.Entry> entries1 = ga.getEntries(startDate, endDate, dimensions1, metrics1);
            system.debug('@uniqueevententries ' +entries1);
                        
            for (GoogleAnalytics.Entry entry : entries1) {
                Site_Event__c event = new Site_Event__c(
                    Name = 'Event',
                    Category__c = entry.getDimension(GoogleAnalytics.EventCategoryDimension),
                    Action__c = entry.getDimension(GoogleAnalytics.EventActionDimension),
                    Count__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.UniqueEventsMetric)),
                    Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)),
                    Metric_Name__c = 'Unique Events');
                events.add(event);
            }

            
            insert events;
        }
    }
        
        
          //Class to import Session Data for browser , username, Affiliate,Region,
        public static void importSessions1(string siteMetricSettingsName,boolean TodaysData) {
        if(initialize(siteMetricSettingsName)) {        
                       Site_Metric_Settings__c settings;
                      Date startDate ;
                      Date endDate;
            If (TodaysData == true) // If we want to fetch only todays dataas normally
            {startdate = (System.Today()).adddays(-1);endDate = (System.Today()).adddays(-1);}        
            else{// we fetch the data from 17 for a week
            //startdate = Date.newInstance(2014, 10, 17);
            settings = [Select s.Start_Date__c,s.End_Date__c,s.Table_Id__c, s.Password__c, s.Email__c From Site_Metric_Settings__c s where s.Name = :siteMetricSettingsName];
            startDate = settings.Start_Date__c;
            endDate = settings.End_Date__c;
            }      
            //Date endDate = (System.Today()).adddays(-1);
            List<String> metrics = new List<String>{GoogleAnalytics.SessionMetric};         
            List<String> dimensions = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.BrowserDimension};
        
            list<GoogleAnalytics.Entry> entries = ga.getEntries(startDate, endDate, dimensions, metrics);
            system.debug('@uniqueevententries ' +entries);
            list<Site_Session__c> sessions = new list<Site_Session__c>();
            
            for (GoogleAnalytics.Entry entry : entries) {
                Site_Session__c session = new Site_Session__c(
                   // User_Full_Name__c = entry.getDimension(GoogleAnalytics.CustomDimension3),
                   // Region__c = entry.getDimension(GoogleAnalytics.CustomDimension1),
                    Browser__c = entry.getDimension(GoogleAnalytics.BrowserDimension),
                  //  Day_Of_Week__c = entry.getDimension(GoogleAnalytics.DayOfWeekDimension),
                    Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.SessionMetric)),
                    Session_Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)));
                   // Affiliate__c =entry.getDimension(GoogleAnalytics.CustomDimension2));
                sessions.add(session);
            }
            
                List<String> metrics1 = new List<String>{GoogleAnalytics.SessionMetric};         
                List<String> dimensions1 = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.DayOfWeekDimension};
        
            list<GoogleAnalytics.Entry> entries1 = ga.getEntries(startDate, endDate, dimensions1, metrics1);
            system.debug('@uniqueevententries ' +entries1);
                      
            for (GoogleAnalytics.Entry entry : entries1) {
                Site_Session__c session = new Site_Session__c(
                 
                    Day_Of_Week__c = entry.getDimension(GoogleAnalytics.DayOfWeekDimension),
                 
                    Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.SessionMetric)),
                    Session_Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)));
                 
                sessions.add(session);
            }
            List<String> metrics2 = new List<String>{GoogleAnalytics.SessionMetric};         
            List<String> dimensions2 = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.CustomDimension1};
        
            list<GoogleAnalytics.Entry> entries2 = ga.getEntries(startDate, endDate, dimensions2, metrics2);
            system.debug('@uniqueevententries ' +entries2);
                        
            for (GoogleAnalytics.Entry entry : entries2) {
                Site_Session__c session = new Site_Session__c(
                  
                    Region__c = entry.getDimension(GoogleAnalytics.CustomDimension1),
                 
                    Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.SessionMetric)),
                    Session_Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)));
                
                sessions.add(session);
            }
            List<String> metrics3 = new List<String>{GoogleAnalytics.SessionMetric};         
            List<String> dimensions3 = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.CustomDimension2};
        
            list<GoogleAnalytics.Entry> entries3 = ga.getEntries(startDate, endDate, dimensions3, metrics3);
            system.debug('@uniqueevententries ' +entries3);
                       
            for (GoogleAnalytics.Entry entry : entries3) {
                Site_Session__c session = new Site_Session__c(
                  
                    Affiliate__c = entry.getDimension(GoogleAnalytics.CustomDimension2),
              
                    Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.SessionMetric)),
                    Session_Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)));
                  
                sessions.add(session);
            }
            List<String> metrics4 = new List<String>{GoogleAnalytics.SessionMetric};         
            List<String> dimensions4 = new List<String>{GoogleAnalytics.DateDimension, GoogleAnalytics.CustomDimension3};
        
            list<GoogleAnalytics.Entry> entries4 = ga.getEntries(startDate, endDate, dimensions4, metrics4);
            system.debug('@uniqueevententries ' +entries4);
             
            for (GoogleAnalytics.Entry entry : entries4) {
                Site_Session__c session = new Site_Session__c(
                   
                    User_Full_Name__c = entry.getDimension(GoogleAnalytics.CustomDimension3),
                 
                    Value__c = decimal.ValueOf(entry.getMetric(GoogleAnalytics.SessionMetric)),
                    Session_Date__c = GoogleAnalytics.parseDate(entry.getDimension(GoogleAnalytics.DateDimension)));
                 
                sessions.add(session);
            }


            
            insert sessions;
        }
    }
    
  
    
    static boolean initialize(string siteMetricSettingsName) {
        Site_Metric_Settings__c settings;
        
        try {
            settings = [Select s.EndPoint__c,s.claim_set_aud__c,s.claim_set_exp__c,s.claim_set_iat__c,s.claim_set_iss__c,s.claim_set_scope__c,s.ContentType__c,s.ContentTypeValue__c,s.EndPointValue__c,s.grant_typeValue__c,s.Header__c,s.Method__c,s.Private_key1__c,s.Private_key2__c,s.Private_key3__c,s.Private_key4__c,s.Private_key5__c,s.Private_key6__c,s.Private_key7__c,s.RSA_Value__c,s.Start_Date__c,s.End_Date__c,s.Table_Id__c, s.Password__c, s.Email__c From Site_Metric_Settings__c s where s.Name = :siteMetricSettingsName];
        } catch (QueryException ex) {
            System.debug(Logginglevel.WARN, 'No Site Metric Settings with Name = ' + siteMetricSettingsName + '; stopping import');
            return false;
        }       

        ga = new GoogleAnalytics(settings); 
        return true;
    }   
}