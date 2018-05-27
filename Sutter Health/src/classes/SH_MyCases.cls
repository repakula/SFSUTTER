/*
    This class is used show comments on page
    ===============================================
    Name                 Date               version
    ===============================================
    Prashant Kumar     7/29/2015               1.0
    ===============================================
*/
public class SH_MyCases extends SH_BaseController 
{
    //class level variables
    public list<Case> lstCase {get; set;}
    public String strCase {get; set;} 
    public string strBreadCrum {get;set;}
    //added on 30-Dec-2015 on Sutter Request
    public string selectedSortField {get;set;}
        
    /*
        Constructor is used to Initialise the variables
        ================================================
        Name                Date                version
        ================================================
        Prashant Kumar      7/29/2015            1.0
        ================================================     
        Input Param: None
        =================================================
        Output : None
        =================================================       
    */
    public SH_MyCases()
    {
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName =  'Service Request';
        //BreadCrumbs.add(new SH_BreadCrumb('Help' , 'sh_Help_Support'));
        setBreadCrumbs(); 
        BreadCrumbs.add(new SH_BreadCrumb('Service Request' , '#'));
        
        strCase = Apexpages.currentPage().getParameters().get('C');
        GetCases(); 
        strBreadCrum = SH_Common.getUrlParamString()+'&isHelp=true';
        
        //added on 30-Dec-2015 on Sutter Request
        selectedSortField = 'Date (Newest First)';
    }
    /*
    This method is used get Cases based on url Param
    ===============================================
    Name                 Date               version
    ===============================================
    Prashant Kumar     7/29/2015               1.0
    ===============================================
    Input Param: None
    ================================================
    Output : None
    ================================================
    */
    public void GetCases()
    {
        //commented on 29-Sep-2015 on Sutter Request
        /*
        if(strCase == 'C')
        {
            lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() and IsClosed = true order by CreatedDate desc limit 999];
        }
        else
        {
            lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId()  and IsClosed = false order by CreatedDate desc limit 999];
        } 
        */       
        //modified on 30-Dec-2015 on Sutter Request
        /*lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by IsClosed, CreatedDate desc limit 999];    
        */
        lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c, Comments__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by CreatedDate desc limit 999]; 
    }  
    /*
    This method is used to sort the cases
    ===============================================
    Name                 Date               version
    ===============================================
    Prashant Kumar     12/30/2015               1.0
    ===============================================
    Input Param: None
    ================================================
    Output : None
    ================================================
    */
    public void sortCases() {
        if(string.isNotBlank(selectedSortField)) {
            if(selectedSortField.equalsIgnoreCase('Status (Ascending)')) {
                lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c,Comments__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by status asc limit 999]; 
            }
            else if(selectedSortField.equalsIgnoreCase('Status (Descending)')) {
                lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c,Comments__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by status desc limit 999]; 
            }
            else if(selectedSortField.equalsIgnoreCase('Date (Oldest First)')) {
                lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c,Comments__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by CreatedDate asc limit 999]; 
            }
            else{
                lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c,Comments__c, Sub_Function__c, CreatedDate, ClosedDate, Customer_Intent__c 
                        from Case where CreatedById =: Userinfo.getUserId() order by CreatedDate desc limit 999]; 
            }
        }
    }
}