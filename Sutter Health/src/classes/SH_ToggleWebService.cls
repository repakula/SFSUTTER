/*
    This class used to toggle the boolean value on the object
    --------------------------------------------------------------------------------------
    Version#     Date                           Author                    Description
    --------------------------------------------------------------------------------------
    1.0          07-Aug-2015                    Alok Verma                Initial Version
    --------------------------------------------------------------------------------------
*/   
global class SH_ToggleWebService{

    WebService static boolean togglePublishChk(string objectName, string fieldName, string recordId) {
    
      if(objectName!=null && fieldName!=null && recordId!=null) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType ctype = gd.get(objectName);
        if(ctype!=null) {
            SObject obj=ctype.newSObject();
            String SOQL='Select Id,' + fieldName + ' From ' + objectName + ' where Id= \'' + recordId +'\'';
            obj=Database.Query(SOQL);
                if(obj!=null) {
                    boolean value= (boolean)obj.get(fieldName);
                    obj.put(fieldName,!value);
                    update obj;
                    return !value;
                }      
            }
         return null;    
        }
        return null;    
    }
}