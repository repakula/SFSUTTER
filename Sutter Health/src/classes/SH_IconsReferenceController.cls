/*
    This class is used to assign Icons on object
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Rishabh Pilani          7/31/2015                   1.0
    ==========================================================  
*/
public class SH_IconsReferenceController {

    public String SelectedIconCss { get; set; }
    private id MenuId{ get; set; }
    
     /*
      constructor used to initialize the variables
      ===================================================================
      Name                    Date                       version
      ===================================================================
      Rishabh Pilani          7/31/2015                   1.0
      ===================================================================
    */
    public SH_IconsReferenceController(){
        MenuId = ApexPages.currentPage().getParameters().get('id');
    }
    /*
      This method is used to assign the selected icon on record
      ===================================================================
      Name                    Date                       version
      ===================================================================
      Rishabh Pilani          7/31/2015                   1.0
      ===================================================================
    */
    public pagereference UpdateSelectedIcon(){
        pagereference pr = null;
        if(MenuId != null){
            try {
            SObject o1 = MenuId.getSObjectType().newSObject(MenuId);
            o1.put('SH_Icon__c', SelectedIconCss);            
            update o1;
            }
            catch(Exception ee) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
            pr = new pagereference('/'+ MenuId);
            pr.setredirect(true);
        }
        return pr;
    }
    /*
      This method is used to return on the record
      ===================================================================
      Name                    Date                       version
      ===================================================================
      Rishabh Pilani          7/31/2015                   1.0
      ===================================================================
    */
    public Pagereference Cancel()
    {
        PageReference objRefrence = new PageReference('/' + MenuId);  
        objRefrence.setRedirect(true);  
        return objRefrence;
    }
}