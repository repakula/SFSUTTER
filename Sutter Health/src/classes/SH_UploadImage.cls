/*
	This class is used to upload the image
	================================================================
	Name 						   Date 					  version
	================================================================
	Prashant Kumar				  9/25/2015						1.0
	================================================================
*/
public class SH_UploadImage 
{
    private ID parentID;
    private string strObjeectApiName;
    public string fileName {get;set;}  
    public Blob fileBody {get;set;}  
    public string strErrorMessage {get; set;}
    public string strInfo {get; set;}
    public string strName {get; set;}
    public string strImageTypes {get; set;}
    
    //File dimensions
    public decimal intHeight {get; set;}
    public decimal intWidth {get; set;}
    
    //constructor
    public SH_UploadImage () 
    {
        strErrorMessage = '';
        
        parentID = ApexPages.currentPage().getParameters().get('id');
        strObjeectApiName = ApexPages.currentPage().getParameters().get('API');
        strName = ApexPages.currentPage().getParameters().get('Name');
        
        GetDimension();
    }
    
    /*
		This Method is used to Get Dimension from custom setting
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant kumar				  9/25/2015						1.0
		================================================================
		Input Param: None
		================================================================
		Output : None
		================================================================	
	*/
    public void GetDimension()
    {
        Image_Dimension__c objDimension = Image_Dimension__c.getValues(strObjeectApiName);
        
        if(objDimension != null && objDimension.SH_Height__c != null && objDimension.SH_Width__c != null && objDimension.SH_Image_Types__c != null)
        {
            intHeight = objDimension.SH_Height__c;
            intWidth = objDimension.SH_Width__c;
            strInfo = 'Image with dimensions (' + integer.valueOf(intWidth) + ', ' + integer.valueOf(intHeight) + ') used for internal and extarnal pages';
            strImageTypes = objDimension.SH_Image_Types__c;   
        }
        else
        {
            strErrorMessage = 'Please contact your administrator to set image dimensions and types.';
        }
    }
    
    /*
		This Method is used to save attachment
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant kumar				  9/25/2015						1.0
		================================================================
		Input Param: None
		================================================================
		Output : PageReference
		================================================================	
	*/
    public PageReference SaveAttachment() 
    {  
        if(fileBody != null && fileName != null) 
        { 
              try{
              Attachment myAttachment  = new Attachment();  
              myAttachment.Body = fileBody;  
              myAttachment.Name = fileName;  
              myAttachment.ParentId = parentID;
              insert myAttachment;
              
              SObject objObject = parentID.getSObjectType().newSObject(parentID);
              objObject.put('SH_Content_Image_Url__c', 'servlet/servlet.FileDownload?file='+ myAttachment.Id);            
              update objObject;
                
              PageReference objRefrence = new PageReference('/' + parentID);  
              objRefrence.setRedirect(true);  
              return objRefrence;  
              }
              catch(Exception ee) {
                  //strErrorMessage = ee.getMessage();
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage());
                  ApexPages.addMessage(myMsg);
              }
        }  
        return null;  
    }     
    
    /*
		This Method is used for cancel action
		================================================================
		Name 						   Date 					  version
		================================================================
		Prashant kumar				  9/25/2015						1.0
		================================================================
		Input Param: None
		================================================================
		Output : PageReference
		================================================================	
	*/
    public Pagereference Cancel()
    {
        PageReference objRefrence = new PageReference('/' + parentID);  
        objRefrence.setRedirect(true);  
        return objRefrence;
    }  
}