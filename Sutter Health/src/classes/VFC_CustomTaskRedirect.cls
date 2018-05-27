public class VFC_CustomTaskRedirect{
    public VFC_CustomTaskRedirect() {}
    
    public PageReference redirectToTask() {
        try {
            Schema.DescribeSObjectResult taskDescObj = Schema.SObjectType.Task; 
            Map<Id,Schema.RecordTypeInfo> rtMapById = taskDescObj.getRecordTypeInfosById();
            Map<String,Schema.RecordTypeInfo> rtMapByName = taskDescObj.getRecordTypeInfosByName();
            PageReference pgRef = new PageReference('/00T/e');
            if(ApexPages.CurrentPage().getParameters().get('who_id') != null) {
                pgRef.getParameters().put('who_id',ApexPages.CurrentPage().getParameters().get('who_id'));
            }
            if(ApexPages.CurrentPage().getParameters().get('what_id') != null) {
                pgRef.getParameters().put('what_id',ApexPages.CurrentPage().getParameters().get('what_id'));
            }
            if(ApexPages.CurrentPage().getParameters().get('retURL') != null) {
                pgRef.getParameters().put('retURL',ApexPages.CurrentPage().getParameters().get('retURL'));
            }
            if(ApexPages.CurrentPage().getParameters().get('ent') != null) {
                pgRef.getParameters().put('ent','Task');
            } 
            string recordTypeId;            
            if(ApexPages.CurrentPage().getParameters().get('RecordTypeName') != null) {
                recordTypeId = rtMapByName.get(ApexPages.CurrentPage().getParameters().get('RecordTypeName')).getRecordTypeId();
                pgRef.getParameters().put('RecordType',recordTypeId);
            }
            pgRef.setRedirect(true);
            return pgRef;
        } catch(Exception ex) {}
        return null;
    }     
}