/**  
*    Class Name: GoogleAnalyticsImporter 
*    Author: Saket
*    Date: 14-August-2014
*    Description: Schedular class for Google Anaytics
*    History
*    --------
**/
global with sharing class GoogleAnalyticsImporterSession implements Schedulable
 {
        public static string jobname = 'Google Analytic importer' ;
        public static String sched = '0 0 01 * * ?'; // schedule time 1 a.m. Every day to fetch previous days data (manually scheduled as apex job so not needed)
        boolean AllorTodayDataSession ; // false all data is fetched starting from 06 may,true will fetch only todays data. 
        boolean AllorTodayDataEvent ; // false all data is fetched starting from 06 may,true will fetch only todays data. 
    global void execute(SchedulableContext SC) {
    
        System.debug('Starting Scheduled job @ ' + Date.today());
         Site_Metric_Settings__c settings;
        
        try {
            settings = [Select s.Table_Id__c,Track_Sessions__c,Tracking_Sessions__c,Track_Events__c,Tracking_Events__c From Site_Metric_Settings__c s where s.Name = :System.Label.CL52_Google_Analytics Limit 1];
            
            AllorTodayDataSession = settings.Tracking_Sessions__c ;
            AllorTodayDataEvent = settings.Tracking_Events__c ;
        } catch (QueryException ex) {
            System.debug(Logginglevel.WARN, 'No Site Metric Settings with Name = ' + System.Label.CL52_Google_Analytics + '; stopping import');
            
        } 
        
        ImportGoogleAnalytics diw = new ImportGoogleAnalytics();
        
        If (settings.Track_Sessions__c == true) // If sessions are to be tracked then run the methods
        {
        ImportGoogleAnalytics.callSessionMethods(AllorTodayDataSession);
        settings.Tracking_Sessions__c = true; // updates the setting to have tracking true after the first run
        }
     //GoogleAnalyticsImporter GoogleImp = new GoogleAnalyticsImporter();
    // system.schedule(jobname, sched ,GoogleImp);
        update settings;
        System.debug('Finished Scheduled job1 @ ' + Date.today()); 
    }
}