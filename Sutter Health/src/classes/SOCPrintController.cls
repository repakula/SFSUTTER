public class SOCPrintController {

    private Contact_Validation_Summary__c summaryRecord;
    private PDV_EAF_Facility__c facilityRecord;
    public String recordId;
    public String socName;
    
    public String provider_facility_name {get; set;}
    public String streetAddress {get; set;}
    public String suite {get; set;}
    public String floor {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String zipCode {get; set;}
    public String AttTo {get; set;}
    
    private Map<string , string> objectPrefixMap = new Map<string, string>();
    
    private static final string PROVIDER_SUMMARY_STRING = 'ProviderSummary';
    private static final string EAF_FACILITY_STRING = 'EAF_Facility';
    private static final string COMMA_STRING = ', ';
    private static final string BLANK_STRING = ' ';
    private static final string SUITE_STRING = 'Suite';
    private static final string FLOOR_STRING = 'Floor';
    
    public SOCPrintController(){
        
            recordId = ApexPages.currentPage().getParameters().get('Id');
            
            socName = ApexPages.currentPage().getParameters().get('socName');
            
            provider_facility_name = '';
            AttTo = '';
            streetAddress = '';
            suite = '';
            floor = '';
            city = '';
            state = '';
            zipCode = '';
            
            setObjectPrefix();
            
            if(!string.isBlank(recordId)){
                
                if(recordId.substring(0,3) == objectPrefixMap.get(PROVIDER_SUMMARY_STRING)){
                    
                    Contact_Validation_Summary__c summaryRecord = [Select Printed_Contact_Name__c, Printed_Street_Address__c, Printed_Suite__c,
                                                                        Printed_Floor__c, Printed_City__c, Printed_State__c, Printed_Zip_Code__c,Attn_To__c
                                                                        FROM Contact_Validation_Summary__c
                                                                        WHERE Id =:recordId];
                    if(summaryRecord <> null){
                        
                        
                        if(!String.isblank(summaryRecord.Attn_To__c)){
                            AttTo = 'Attn To:'+ summaryRecord.Attn_To__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_Contact_Name__c)){
                            provider_facility_name = summaryRecord.Printed_Contact_Name__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_Street_Address__c)){
                            streetAddress = summaryRecord.Printed_Street_Address__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_Suite__c)){
                            suite = SUITE_STRING + BLANK_STRING + summaryRecord.Printed_Suite__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_Floor__c)){
                            floor = FLOOR_STRING + BLANK_STRING + summaryRecord.Printed_Floor__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_City__c)){
                            city = summaryRecord.Printed_City__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_State__c)){
                            state = summaryRecord.Printed_State__c + COMMA_STRING;
                        }
                        if(!String.isblank(summaryRecord.Printed_Zip_Code__c)){
                            zipCode = summaryRecord.Printed_Zip_Code__c;
                        }
                    }
                }
                else if(recordId.substring(0,3) == objectPrefixMap.get(EAF_FACILITY_STRING)){
                    
                    PDV_EAF_Facility__c facilityRecord = [Select Name, ADDRESS__c, Suite__c, Floor__c, CITY__c, STATE__c, ZIP_CODE__c,Attn_To__c
                                                                        FROM PDV_EAF_Facility__c
                                                                        WHERE Id =:recordId];
                    if(facilityRecord <> null){
                        
                        
                        if(!String.isblank(facilityRecord.Attn_To__c)){
                            AttTo = 'Attn To:'+facilityRecord.Attn_To__c+ COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.Name)){
                            provider_facility_name = facilityRecord.Name + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.ADDRESS__c)){
                            streetAddress = facilityRecord.ADDRESS__c + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.Suite__c)){
                            suite = SUITE_STRING + BLANK_STRING + facilityRecord.Suite__c + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.Floor__c)){
                            floor = FLOOR_STRING + BLANK_STRING + facilityRecord.Floor__c + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.CITY__c)){
                            city = facilityRecord.CITY__c + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.STATE__c)){
                            state = facilityRecord.STATE__c + COMMA_STRING;
                        }
                        if(!String.isblank(facilityRecord.ZIP_CODE__c)){
                            zipCode = facilityRecord.ZIP_CODE__c;
                        }
                    }
                }
            }
            socName = socName .replace(',','');
            Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + socName + '.pdf');
        
    }
    
    public void setObjectPrefix(){
        
        schema.DescribeSObjectResult summaryResult = Contact_Validation_Summary__c.SObjectType.getDescribe();
        string summaryPrefix = summaryResult.getKeyPrefix();
        objectPrefixMap.put('ProviderSummary', summaryPrefix);
        
        schema.DescribeSObjectResult facilityResult = PDV_EAF_Facility__c.SObjectType.getDescribe();
        string facilityPrefix = facilityResult.getKeyPrefix();
        objectPrefixMap.put('EAF_Facility', facilityPrefix);
    }
}