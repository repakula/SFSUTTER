/**    
 *     Class Name  : ManageChatterPostActions
 *     Author      : IDC Offshore  
 *     Date        : 20-Oct-2015  
 *     Project Name: CRM - SFT - Sutter Health  
 *     Description : ManageChatterPostActions Contains set of Methods related to the actions performed 
 *                   to auto post Chatter Suggestion Comments based on detection of particular keywords.                      
 **/
public Class ManageChatterPostActions {
    
    public static String BENEFITGRID = 'Benefits';
    public static String BACKSLASH = '/';
    public static String TABLINKFORMAT = '/o';
    public static String NEWLINE = '\n';
    public static String MEMBERCONKEY = 'MemberCon';
    public static String PROVIDERCONKEY = 'ProviderCon';
    public static String BROKERCONKEY = 'BrokerCon';
    public static String EMPLOYERCONKEY = 'EmployerCon';
    public static String LISTVIEWFORMAT = '?fcf=';
    public static String MEMBERLISTVIEWNAME = 'SHP Member Contacts';
    public static String PROVIDERLISTVIEWNAME = 'Provider Contact';
    public static String BROKERLISTVIEWNAME = 'SHP Broker Reps';
    public static String EMPLOYERLISTVIEWNAME = 'SHP Employer Contacts';
    public static String MEMBERACNTKEY = 'MemberAcnt';
    public static String BROKERACNTKEY = 'BrokerAcnt';
    public static String EMPLOYERACNTKEY = 'EmployerAcnt';
    public static String SUBSCRIBERACNTKEY = 'SubscriberAcnt';
    public static String MEMBERACNTVIEWNAME = 'All Accounts';
    public static String EMPLOYERACNTVIEWNAME = 'All Employers';
    public static String BROKERACNTVIEWNAME = 'All Brokers';
    public static String SUBSCRIERACNTVIEWNAME = 'All Subscribers';
    public static String PQIKEY = 'PQI';
    public static String SCNKEY = 'SCN';
    public static String CORRESPONDECETEMPLATE = 'Correspondence Template';
    public static String GRIEVANCEKEY = 'Grievance';
    public static String SHPIL = 'SHP IL';
    public static String SHPSR = 'SHP SR';
    public static String MEDMANAGEMENT = 'Medical Management';
    public static String SCNREPORT = 'Sold Case';
    public static String SHPSURVEY = 'SHP Survey';
    public static String MEMBERREPORT = 'Member';
    public static String BROKERREPORT = 'Broker';
    public static String EMPLOYEREPORT = 'Employer';
    public static String PROVIDEREPORT = 'Provider';
    public static String CORRESPONDREPORT = 'Correspondence';
    public static String REPORTLINKFORMAT = '. Link to Report \' ';
    public static String ESCAPECHARCOLAN = ' \' : ';
    public static String APPEALKEYWORD = 'Appeal';
    public static String CONTACTKEY = 'Contact';
    public static String ACCOUNTKEY = 'Account';
    public static String ONLINESTRING = 'Online';
    public static String LANGUAGESTRING = 'en_US';
    public static String PQISEARCHSTRING = '%PQI%';
    public static String SCNSEARCHSTRING = '%SCN%';
    public static String CORRESPONDENCESEARCHSTRING = '%Correspondence%';
    public static String GRIEVANCESEARCHSTRING = '%Grievanc%';
    public static String SHPSEARCHSTRING = '%shp%'; 
    public static String ILSEARCHSTRING = '%IL%';
    public static String SRSEARCHSTRING = '%SR%';
    public static String MEDICALSEARCHSTRING = '%Medical%';
    public static String MANAGEMENTSEARCHSTRING = '%Management%';
    public static String SOLDSEARCHSTRING = '%Sold%';
    public static String CASESEARCHSTRING = '%Case%';
    public static String SURVEYSEARCHSTRING = '%Survey%';
    public static String MEMBERSEARCHSTRING = '%Member%';
    public static String BROKERSEARCHSTRING = '%Broker%';
    public static String EMPLOYERSEARCHSTRING = '%Employer%';
    public static String PROVIDERSEARCHSTRING = '%Provider%';
    public static String APPEALSEARCHSTRING = '%Appeal%';
   

    /**
    *   @Description: Methods creates Salesforce Tab Link for Detected KeyWord in Chatter Post as a suggestion Link.
    *   @Arguments: FeedItem ChatterPost, String DetectedKeyword     
    *   @Return: String ReturnTabUrl
    **/
    Public static String getTabLinkForDetectedKeyword( String DetectedKeyword ) {
        String ORGURL = URL.getSalesforceBaseUrl().toExternalForm() + BACKSLASH ;
        String ReturnTabUrl = ORGURL;
        
        if ( DetectedKeyword.equalsIgnoreCase(BENEFITGRID)) {
            Schema.DescribeSObjectResult Objectdetail = SHP_Benefit_Grid__c.sObjectType.getDescribe();
            String keyPrefix = Objectdetail.getKeyPrefix();
            ReturnTabUrl = ReturnTabUrl + keyPrefix + TABLINKFORMAT ;
            return ReturnTabUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(MEMBERCONKEY) || DetectedKeyword.equalsIgnoreCase(PROVIDERCONKEY) || DetectedKeyword.equalsIgnoreCase(BROKERCONKEY) ||
            DetectedKeyword.equalsIgnoreCase(EMPLOYERCONKEY)) {
                Schema.DescribeSObjectResult Objectdetail = Contact.sObjectType.getDescribe();
                String keyPrefix = Objectdetail.getKeyPrefix();
                ReturnTabUrl = ReturnTabUrl + keyPrefix + LISTVIEWFORMAT ;
                Map<String , String > ListViewNameIDMap = new Map<String , String >();
                
                for ( ListView Views :[SELECT Id,Name FROM ListView WHERE SobjectType = :CONTACTKEY] ) {
                    String ListViewId = Views.Id;
                    ListViewNameIDMap.put( Views.Name , ListViewId.substring(0,15));
                }
                
                if( DetectedKeyword.equalsIgnoreCase(MEMBERCONKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMap.get(MEMBERLISTVIEWNAME);
                }
                
                if( DetectedKeyword.equalsIgnoreCase(PROVIDERCONKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMap.get(PROVIDERLISTVIEWNAME);
                }
                
                if( DetectedKeyword.equalsIgnoreCase(BROKERCONKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMap.get(BROKERLISTVIEWNAME);
                }
                
                if( DetectedKeyword.equalsIgnoreCase(EMPLOYERCONKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMap.get(EMPLOYERLISTVIEWNAME);
                }
                return ReturnTabUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(MEMBERACNTKEY) || DetectedKeyword.equalsIgnoreCase(BROKERACNTKEY) || DetectedKeyword.equalsIgnoreCase(EMPLOYERACNTKEY) ||
            DetectedKeyword.equalsIgnoreCase(SUBSCRIBERACNTKEY)) {
                Schema.DescribeSObjectResult Objectdetail = Account.sObjectType.getDescribe();
                String keyPrefix = Objectdetail.getKeyPrefix();
                ReturnTabUrl = ReturnTabUrl + keyPrefix + LISTVIEWFORMAT ;
                Map<String , String > ListViewNameIDMapAccount = new Map<String , String >();
                
                for( ListView Views :[SELECT Id,Name FROM ListView WHERE SobjectType = :ACCOUNTKEY] ) {
                    String ListViewId = Views.Id;
                    ListViewNameIDMapAccount.put( Views.Name , ListViewId.substring(0,15) );
                }
               /* 
                if( DetectedKeyword.equalsIgnoreCase(MEMBERACNTKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMapAccount.get(MEMBERACNTVIEWNAME);
                }*/
                
                if( DetectedKeyword.equalsIgnoreCase(BROKERACNTKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMapAccount.get(BROKERACNTVIEWNAME);
                }
                
                if( DetectedKeyword.equalsIgnoreCase(EMPLOYERACNTKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMapAccount.get(EMPLOYERACNTVIEWNAME);
                }
                
                if( DetectedKeyword.equalsIgnoreCase(SUBSCRIBERACNTKEY)) {
                    ReturnTabUrl = ReturnTabUrl + ListViewNameIDMapAccount.get(SUBSCRIERACNTVIEWNAME);
                }
                return ReturnTabUrl;       
        }
        return null;    
    }
    
    /**
    *   @Description: Methods creates Salesforce Training Document links for Detected KeyWord in Chatter Post as a suggestion Link.
    *   @Arguments: String DetectedKeyword     
    *   @Return: String ReturnTabUrl
    **/
    Public static String getTrainingDocumentLinkForRespectiveKeyword( String DetectedKeyword ) {
        String ORGURL = URL.getSalesforceBaseUrl().toExternalForm() + BACKSLASH ;
        String ReturnTabUrl = ORGURL;
        
        if( DetectedKeyword.equalsIgnoreCase(PQIKEY)) {
            Id PQITainingDocId = [SELECT Id,Title From SHP_Training_Document__kav WHERE PublishStatus = 'Online' AND Language = 'en_US'  AND Title like :PQISEARCHSTRING limit 1].Id;
            
            if( PQITainingDocId != null ) {
                ReturnTabUrl = ReturnTabUrl + PQITainingDocId;
                return ReturnTabUrl;
            }
        }
        
        if( DetectedKeyword.equalsIgnoreCase(SCNKEY)) {
            Id SCNTainingDocId = [SELECT Id,Title From SHP_Training_Document__kav WHERE PublishStatus = 'Online' AND Language = 'en_US' AND Title like :SCNSEARCHSTRING limit 1].Id;
            
            if( SCNTainingDocId != null ) {
                ReturnTabUrl = ReturnTabUrl + SCNTainingDocId;
                return ReturnTabUrl;
            }
        }
        
        if( DetectedKeyword.equalsIgnoreCase(CORRESPONDECETEMPLATE)) {
            Id CorrespondenceTainingDocId = [SELECT Id,Title From SHP_Training_Document__kav WHERE PublishStatus = 'Online' AND Language = 'en_US' AND Title like :CORRESPONDENCESEARCHSTRING limit 1].Id;
            
            if( CorrespondenceTainingDocId != null ) {
                ReturnTabUrl = ReturnTabUrl + CorrespondenceTainingDocId;
                return ReturnTabUrl;
            }
        
        }
        
        return null;
    }
    
    /**
    *   @Description: Methods creates Salesforce Report links for Detected KeyWord in Chatter Post as a suggestion Links to user.
    *   @Arguments: String DetectedKeyword     
    *   @Return: String ReturnTabUrl
    **/
    public static String getReportLinksForRespectiveKeyWords( String DetectedKeyword ) {
        String ORGURL = URL.getSalesforceBaseUrl().toExternalForm() + BACKSLASH ;
        String ReturnUrl = '';
        
        if( DetectedKeyword.equalsIgnoreCase(GRIEVANCEKEY)) {
            List <Report> GrievanceReportList = [ SELECT Id, Name FROM Report WHERE Name like :GRIEVANCESEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !GrievanceReportList.isEmpty() ) {
                for( Integer i =0 ; i< GrievanceReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+GrievanceReportList[i].Name+ESCAPECHARCOLAN+ORGURL+GrievanceReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(SHPIL)) {
            List <Report> SHPILReportList = [ SELECT Id, Name FROM Report WHERE Name like :SHPSEARCHSTRING AND Name like :ILSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPILReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPILReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPILReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPILReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(SHPSR)) {
            List <Report> SHPSRReportList = [ SELECT Id, Name FROM Report WHERE Name like :SHPSEARCHSTRING AND Name like :SRSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPSRReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPSRReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPSRReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPSRReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(MEDMANAGEMENT)) {
            List <Report> SHPMedReportList = [ SELECT Id, Name FROM Report WHERE Name like :MEDICALSEARCHSTRING AND Name like :MANAGEMENTSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPMedReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPMedReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPMedReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPMedReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(SCNREPORT)) {
            List <Report> SHPSCNReportList = [ SELECT Id, Name FROM Report WHERE Name like :SOLDSEARCHSTRING AND Name like :CASESEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPSCNReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPSCNReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPSCNReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPSCNReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(SHPSURVEY)) {
            List <Report> SHPSurveyReportList = [ SELECT Id, Name FROM Report WHERE Name like :SHPSEARCHSTRING AND Name like :SURVEYSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPSurveyReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPSurveyReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPSurveyReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPSurveyReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(MEMBERREPORT)) {
            List <Report> SHPMemberReportList = [ SELECT Id, Name FROM Report WHERE Name like :MEMBERSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPMemberReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPMemberReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPMemberReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPMemberReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(BROKERREPORT)) {
            List <Report> SHPBrokerReportList = [ SELECT Id, Name FROM Report WHERE Name like :BROKERSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPBrokerReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPBrokerReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPBrokerReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPBrokerReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(EMPLOYEREPORT)) {
            List <Report> SHPEmployerReportList = [ SELECT Id, Name FROM Report WHERE Name like :EMPLOYERSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPEmployerReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPEmployerReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPEmployerReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPEmployerReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(PROVIDEREPORT)) {
            List <Report> SHPProviderReportList = [ SELECT Id, Name FROM Report WHERE Name like :PROVIDERSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPProviderReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPProviderReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPProviderReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPProviderReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(CORRESPONDREPORT)) {
            List <Report> SHPCorpReportList = [ SELECT Id, Name FROM Report WHERE Name like :CORRESPONDENCESEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !SHPCorpReportList.isEmpty() ) {
                for( Integer i =0 ; i< SHPCorpReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+SHPCorpReportList[i].Name+ESCAPECHARCOLAN+ORGURL+SHPCorpReportList[i].id;
                }
            }
            return ReturnUrl;
        }
        
        if( DetectedKeyword.equalsIgnoreCase(APPEALKEYWORD)) {
            List <Report> AppealReportList = [ SELECT Id, Name FROM Report WHERE Name like :APPEALSEARCHSTRING ORDER BY LastRunDate DESC NULLS LAST limit 5];
            
            if( !AppealReportList.isEmpty() ) {
                for( Integer i =0 ; i< AppealReportList.size() ;i++ ) {
                    ReturnUrl = ReturnUrl +NEWLINE+(i+1)+REPORTLINKFORMAT+AppealReportList[i].Name+ESCAPECHARCOLAN+ORGURL+AppealReportList[i].id;
                }
            }
            return ReturnUrl;
        }
            
        return null;
    }
    
}