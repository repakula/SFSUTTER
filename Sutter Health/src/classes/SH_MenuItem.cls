/*
    This class is used to create the dynamic MenuItem on page
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar        7/14/2015                        1.0
    ==========================================================  
*/
public class SH_MenuItem 
{
    //Class level variables
    Public String strTestImage {get; set;}
    public list<SH_Menu_Item__c> lstMenuItem {get; set;}
    public boolean Preview {get;set;}
    
    //Constructor
    public SH_MenuItem()
    {
        Initialize();
        BindData();   
    }
    
    public void Initialize()
    {
        lstMenuItem = new list<SH_Menu_Item__c>();
    }
    
    /*
        This method is used to bind the menue data on page
        ==========================================================
        Name                    Date                       version
        ==========================================================
        Prashant Kumar        7/14/2015                        1.0
        ==========================================================  
    */
    //issue with preview need to check, comment by ALok
    public void BindData()
    {
         Preview = false;
         lstMenuItem = !Preview ? [select Id, Name, SH_Icon__c,
                             (select id , Name from Sub_Menu_Items__r where SH_Is_Publish__c = true 
                              order by SH_Order_of_Display__c asc)     
                         from SH_Menu_Item__c
                         where SH_Is_Publish__c = true 
                         order by SH_Order_of_Display__c asc]
                         : [select Id, Name, SH_Icon__c,
                             (select id , Name from Sub_Menu_Items__r where SH_Is_Publish__c = true 
                              order by SH_Order_of_Display__c asc)     
                         from SH_Menu_Item__c
                         where SH_Is_Preview__c = true 
                         order by SH_Order_of_Display__c asc];   

    }
    
    
    
}