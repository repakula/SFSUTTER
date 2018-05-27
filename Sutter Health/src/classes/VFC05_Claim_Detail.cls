/**  
*    Class Name: VFC05_Claim_Detail_Sak
*    Author: Eric Pellish
*    Date: 20-November-2013
*    Description: This class is used as the controller of the claim detail visual force page and pulls claim line information
*    from the HealthEdgeMapping Class to display. This class also controls the pagination of the page in accordance with the 
*    HealthEdgeMappingClass. 
*    History
*    --------
**/

public with sharing class VFC05_Claim_Detail 
{

    public String HCCID;
    public boolean showError{get;set;}
    HealthEdgeMappingClass Mapping = new HealthEdgeMappingClass(); 
    public healthEdgeComExtract.extractPayload extractPayload = new healthEdgeComExtract.extractPayload(); 
    public healthEdgeComExtract.EOBPaymentInformation EOBPaymentInformation = new healthEdgeComExtract.EOBPaymentInformation();
    public claim_line_item claim_line_item{get;set;}
    public claim_line_item claimOne{get; set;}
    public healthEdgeComExtract.payer payer = new healthEdgeComExtract.payer();
    public healthEdgeComExtract.claim claim = new healthEdgeComExtract.claim();
    public  List<claim_line_item> lst_claim_line_item {get; set;}
    public  List<claim_line_item> paginateList{get; set;}
   /* public  string claim_id{get;set;}
    public  string claim_type{get;set;}
    public  string claim_line_no{get;set;}
    public  string claim_date_service{get;set;}
    public  string claim_source{get;set;}*/
    public claim_line_item claimline{get; set;}
    Integer pageNumber = 1; 
    Integer pageSize = 5; 
    Integer incrementList = 0; 
    
    //public VFC05_Claim_Detail_Sak(){}
    //public class extensionClass extends VFC05_Claim_Detail_Sak{}
    
    //@@Description: Getter method returns the value of the paginated list of claim line items
    public  List<claim_line_item> getpaginateList (){ 
        return paginateList; 
    }
    //@@Description: Sets the paginated list to the returned value from the mapping class
    public void setpaginateList () {
        paginateList = Mapping.paginateClaim(incrementList, PageSize, PageNumber); 
    }
    //@@Description: gets the page number
    public Integer getPageNumber(){
        return pageNumber; 
    }
    //@@Description: gets the Page size (amount of claim line items to be displayed)        
    public Integer getPageSize(){
        return pageSize;
    }
    //@@Description: sets the PageNumber
    public void setPageNumber(Integer PageNumber){
        this.PageNumber = PageNumber; 
    }
    //@@Description: sets the increment which dictates where the next paginated list will start        
    public void setListIncrement(Integer pageNumber){
    
        if (pageNumber == 1)
            incrementList = 0; 
        else 
            incrementList = pageSize * (pageNumber-1); 
    }
    //@@Description: determines if the previous button is enabled
    public Boolean getPreviousButtonEnabled() 
    {
        return (pageNumber > 1);
    }
    //@@Description: determines if the next button is enabled 
    public Boolean getNextButtonEnabled()
    {
    System.debug('NextButtonEnabled before IF : ' + PageNumber + ' Size: ' + Mapping.totalListSize()); 
        if ((PageNumber * PageSize) >= Mapping.totalListSize() ){
            system.debug('@@false@@');
            return false;
        }
        else{
                return true;
        }
    }
    //@@Description: Performs the action on next button click if next is enabled
    public PageReference nextBtnClick() {
          if (getNextButtonEnabled()){
                 pageNumber = pageNumber + 1;
                 isPageNumberChanged(true);
                 setPageNumber(PageNumber); 
                 setPaginateList(); 
                 System.debug('PageNumber is ' + pageNumber); 
                 return null;   
           }
           else 
               isPageNumberChanged(false);
               return null; 
    }
    //@@Description: performs the action on previous button click if the previous button is enabled
    public PageReference previousBtnClick() {
    
         if (getPreviousButtonEnabled()){
         pageNumber = pageNumber - 1; 
         isPageNumberChanged(true);  
         setPageNumber(PageNumber); 
         //incrementList = incrementList - PageSize; 
         setPaginateList(); 
         return null; 
         }
         else 
         isPageNumberChanged(false);
             return null;        
    }
    //@@Description: determines if the page number has been changed and invokes the set increment method
    public Integer isPageNumberChanged(Boolean a) {
               if (a){
               setListIncrement(pageNumber); 
               return pageNumber; 
               }
               else
               return pageNumber;          
    }
   /**
    *   @Description: Action of the Visual force page. Passes the HCCID to the request in the Mapping Class. Sets the
    *   paginated list for the visual force to display 
    *   @Arguments: None
    *   @Return: PageReference
    **/
    public pagereference showClaimDetail()
    {
        //*** Create a new paginated list for claim line item ***//
        lst_claim_line_item = new List<claim_line_item>();
        paginateList = new List<claim_line_item>();
        HCCID= ApexPages.CurrentPage().getParameters().get('hccid'); 
        system.debug('@@HCCID:'+HCCID);
        
        Mapping.requestResponseStub(HCCID, IncrementList, PageSize, PageNumber);  
        system.debug('CLAIM SIZE ' + lst_claim_line_item.size()); 
        showError = Mapping.getShowError();
        System.debug('@@ShowError in Controller ' + showError);
       
            paginateList = Mapping.paginateClaim(incrementList, PageSize, PageNumber); 
            lst_claim_line_item = paginateList;
 
        for(claim_line_item claimitem : lst_claim_line_item) {
            
            claimOne = claimitem;
        }
        return null;
    }
    
   }