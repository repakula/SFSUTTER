/*
	This class is used for case comment page
	================================================================
	Name 						   Date 					  version
	================================================================
	Prashant Kumar				  9/25/2015						1.0
	================================================================
*/
public class SH_CaseComment extends SH_BaseController 
{
    //class level variables
    public Case objCase {get; set;}
    public CaseComment objCaseComment {get; set;}
    public string strCaseId {get; set;}
    public string strSuccess {get; set;}
    public list<CaseComment> lstCaseComment {get;set;}
    public boolean isShowCaseClosedMsg {get;set;}
    
    /*
		Constructor of Class
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant Kumar				  9/25/2015						1.0
		================================================================
		Param : none 
		================================================================
	*/
    public SH_CaseComment() {
        strCaseId = Apexpages.currentPage().getParameters().get('Id');
        objCase = new Case();
        lstCaseComment = new list<CaseComment>();
        Intiliaze();
        //BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing'), new SH_BreadCrumb('Help' , 'sh_Help_Support'),new SH_BreadCrumb('Cases' , 'SH_MyCases?C='+Apexpages.currentPage().getParameters().get('C')),new SH_BreadCrumb('Comment' , '#')};
        BreadCrumbs = new list<SH_BreadCrumb>{new SH_BreadCrumb('Home', 'sh_landing')};
        activePgName =  'Comment';
        setBreadCrumbs();        
        BreadCrumbs.add(new SH_BreadCrumb('Comment' , '#'));
        
        strSuccess = 'none';
        //added on Client FeedBack on 04-09-2015 to check if the case is closed then block
        isShowCaseClosedMsg = false;
    }
    
    /*
		This method is used to initialie the variables
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant Kumar				  9/25/2015						1.0
		================================================================
		Param : none 
		================================================================
		Output : none
		================================================================	
	*/
    private void Intiliaze() {
        objCaseComment = new CaseComment(IsPublished= true, ParentId = strCaseId);
        BindData();
    }
    
    /*
		This method is used for binding data on page 
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant Kumar				  9/25/2015						1.0
		================================================================
		Param : none 
		================================================================
		Output : none
		================================================================	
	*/
    private void BindData() {
        if(strCaseId != null && strCaseId != '') {
            list<Case> lstCase = [select Id, subject, status,IsClosed, CaseNumber, Description, Function__c, Sub_Function__c, CreatedDate, ClosedDate,
                                    (Select CommentBody,createdby.name, CreatedDate From CaseComments where IsPublished= true order by CreatedDate desc) 
                                    from Case where Id =: strCaseId];
            
            if(lstCase != null && lstCase.size() > 0) {
                objCase = lstCase[0];
                lstCaseComment = lstCase[0].CaseComments;
            }
                
        }
    }
    
    /*
		This method is used for creating comment 
		================================================================
		Name 					 	  Date 					  version
		================================================================
		Prashant Kumar				  9/25/2015						1.0
		================================================================
		Param : none 
		================================================================
		Output : Pagereference
		================================================================	
	*/
    public Pagereference CreateComment() {
        if(!string.isBlank(strCaseId) && !string.IsBlank(objCaseComment.CommentBody)) {
            try {
                //added on Client FeedBack on 04-09-2015 to check if the case is closed then block
                BindData();
                if(!objCase.IsClosed) {
                    insert  objCaseComment;
                    strSuccess = 'block';
                    Intiliaze();
                }
                else 
                    isShowCaseClosedMsg = true;
                return null; 
            }
            catch(Exception ex){}
        } 
        return null;
    }
}