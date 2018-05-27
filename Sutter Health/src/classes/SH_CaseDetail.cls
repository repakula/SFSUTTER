/*
    This class used to show the Case Detail on Community / portal screen
    ================================================================
    Name                       Date                       version
    ================================================================
    Alok Verma                9/30/2015                     1.0
    ================================================================    
*/
public with sharing class SH_CaseDetail extends SH_BaseController {
    //class members
    public string strCaseId{get;set;}
    public boolean isAccess{get;set;}
    //constructor
    public SH_CaseDetail() {
        Initialize();
    }
    
    /*
        This Method is used to initialize the variables
        ================================================================
        Name                       Date                       version
        ================================================================
        Alok Verma                9/30/2015                     1.0
        ================================================================
        Input Param: None
        ================================================================
        Output : None
        ================================================================    
    */
    private void Initialize() {
        strCaseId = ApexPages.currentPage().getParameters().get('id');
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName = 'SR Detail';
        setBreadCrumbs(); 
        BreadCrumbs.add(new SH_BreadCrumb('SR Detail' , '#'));
        isAccess = false;
        list<case> lstCase = [select id from case where id=:strCaseId ];
        if(lstCase != null && lstCase.size()>0)
            isAccess = true;
        
    }
}