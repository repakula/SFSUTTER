public class AQRSEPICIntegrationController
{
    
    public void communicationLogCreationInEpic(List<Communication_Log__c> lstCommLog) // need to check whether it is a single record or multiple
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HTTPResponse response = new HTTPResponse();
        list<Communication_Log__c> commLogList = new list<Communication_Log__c>();
        commLogList = lstCommLog;
        List<communicationLogWrapper> lstCommLogWrapper = new List<communicationLogWrapper>();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(''); //Epic url if token authentication
        request.setBody('');  //USer credential to connect      
        response = http.send(request);
        if(response.getStatusCode()== 200) // authentication success
        {
            request = new HttpRequest();
            http = new Http();
            request.setMethod('PUT');
            //authentication from above callout
            request.setEndpoint(''); // endpoint url
            
            for(Communication_Log__c cl: lstCommLog) 
            {
                communicationLogWrapper clw = new communicationLogWrapper('Gopika','123',cl.Patient_MRN__c,cl.Department_ID__c,cl.Provider_ID__c,cl.Contact_Name__c,cl.Relationship_to_the_Patient__c,cl.Dialed_Phone__c, cl.Phone_Type_I_CAL_90__c,cl.Comments_Spoke_with_Patient__c,cl.Call_result__c,null,cl.Documentation_Note__c,cl.Reason_for_Call__c,String.valueOf(cl.Encounter_Date__c));
                lstCommLogWrapper.add(clw);
            }
            if(!lstCommLogWrapper.isEmpty())
            {
                request.setBody(JSON.Serialize(lstCommLogWrapper));
                response = http.send(request);
                epicResponseWrapper responseWrapper= (epicResponseWrapper)JSON.deserialize(response.getBody(),epicResponseWrapper.class);
                // Map the EPIC error & Reponse(Exception handling) , update the communication logs 
                	for(Communication_Log__c clog: commLogList){
                		clog.EPIC_Error_Id__c = responseWrapper.ErrorID;
                		if(responseWrapper.ErrorID.contains('INVALID-USERID-<UserID>')){
                			clog.EPIC_Response_Message__c = 'User doesn\'t have active record in Epic';	
                		}else if(responseWrapper.ErrorID.contains('INVALID-PATIENT-ID-<PatientID>')){
                			clog.EPIC_Response_Message__c = 'Patient ID is not in Epic';
                		}else if(responseWrapper.ErrorID.contains('INVALID-SHMRN-<PatientSHMRN>')){
                			clog.EPIC_Response_Message__c = 'Patient doesn\'t have Sutter Health MRN';
                		}else if(responseWrapper.ErrorID.contains('INVALID-MATCH-PATIENTID/SHRMN-<PatientID>/<PatientSHMRN>')){
                			clog.EPIC_Response_Message__c = 'Sutter Health MRN does not belong to Patient ID';
                		}else if(responseWrapper.ErrorID.contains('INVALID-DEPT-ID-<EncounterDept>')){
                			clog.EPIC_Response_Message__c = 'Epic departmeint ID is not found';
                		}else if(responseWrapper.ErrorID.contains('INVALID-PROVIDER-ID-<ProviderID>')){
                			clog.EPIC_Response_Message__c = 'Epic provider ID is not found';
                		}else if(responseWrapper.ErrorID.contains('INVALID-CONTACT-RELATION-ID-<ContactRelation>')){
                			clog.EPIC_Response_Message__c = 'Epic relationship category list ID is invalid';
                		}else if(responseWrapper.ErrorID.contains('INVALID-CONTACT-PHONE-TYPE-ID-<ContactPhoneType>')){
                			clog.EPIC_Response_Message__c = 'Epic phone type cateogry list ID is invalid';
                		}else if(responseWrapper.ErrorID.contains('MISSING-CONTACT-PHONE')){
                			clog.EPIC_Response_Message__c = 'Missing phone number dialed';
                		}else if(responseWrapper.ErrorID.contains('INVALID-CONTACT-OUTCOME-ID-<ContactOutcome>')){
                			clog.EPIC_Response_Message__c = 'Epic contact outcome category list ID is invalid';
                		}else if(responseWrapper.ErrorID.contains('INVALID-REASON-FOR-VISIT-ID-<ReasonForVisit>')){
                			clog.EPIC_Response_Message__c = 'Epic reason for visit category list ID is invalid. This should never occur since you will be always sending 201.';
                		}else if(responseWrapper.ErrorID.contains('ENCOUNTER-NOT-FOUND')){
                			clog.EPIC_Response_Message__c = 'Check after shell encounter is created. This should not occur, but in case it can\'t find the shell encounter it just created.';
                		}else if(responseWrapper.ErrorID.contains('FAILED-TO-CREATE-CONTACT-RECORD')){
                			clog.EPIC_Response_Message__c = 'Error occurred while creating the person contacted record';
                		}else if(responseWrapper.ErrorID.contains('ERROR-OCCURRED-CREATING-REASON-FOR-VISIT')){
                			clog.EPIC_Response_Message__c = 'Error occurred while creating the reason for visit';
                		}else if(responseWrapper.ErrorID.contains('ERROR-OCCURRED-SAVING-NOTE')){
                			clog.EPIC_Response_Message__c = 'Error occurred saving the telephone note.';
                		}else if(responseWrapper.ErrorID.contains('ERROR-CLOSING-TELEPHONE-ENCOUNTER')){
                			clog.EPIC_Response_Message__c = 'Error occurred when closing the telephone encounter';
                		}else if(responseWrapper.ErrorID.contains('ENCOUNTER-DATE-MUST-BE-LESS-THAN-30-DAYS-OLD')){
                			clog.EPIC_Response_Message__c = 'Checking Encounter Date is valid';
                		}else if(responseWrapper.ErrorID.contains('ENCOUNTER-DATE-CANNOT-BE-IN-THE-FUTURE')){
                			clog.EPIC_Response_Message__c = 'Checking Encounter Date is valid';
                		}else {
                			clog.EPIC_Response_Message__c = responseWrapper.ErrorMessage;
                		}
		        		clog.EPIC_Reference__c = '';
		        		clog.EPIC_Sync_Date__c = system.today();
                	}
                	update commLogList;
            }
        }else{ // Log exception if Service is unavailable
        	for(Communication_Log__c cl: commLogList){
        		cl.EPIC_Error_Id__c = response.getStatusCode()+' Service Unavailable';
        		cl.EPIC_Reference__c = '';
        		cl.EPIC_Response_Message__c = response.getBody();  
        		cl.EPIC_Sync_Date__c = system.today();
        	}
        	update lstCommLog;
        }
        
    }
    
        
    public class communicationLogWrapper
    {
        public String UserID;
        public String PatientID;
        public String PatientSHMRN;
        public String EncounterDept;
        public String EncounterProviderID;
        public String ContactName;
        public String ContactRelation;
        public String ContactPhone;
        public String ContactPhoneType;
        public String ContactComment;
        public String ContactOutcome;
        public String NoteFormat;
        public String NoteText;
        public String ReasonForVisit;
        public String EncounterDate;
        public communicationLogWrapper(String cUserID, String cPatientID, String cPatientSHMRN, String cEncounterDept, String cEncounterProviderID, String cContactName, String cContactRelation, String cContactPhone, String cContactPhoneType, String cContactComment, String cContactOutcome, String cNoteFormat, String cNoteText, String cReasonForVisit, String cEncounterDate)
        {
            UserID = cUserID; 
            PatientID = cPatientID;
            PatientSHMRN =  cPatientSHMRN; 
            EncounterDept = cEncounterDept;
            EncounterProviderID = cEncounterProviderID;
            ContactName = cContactName;
            ContactRelation = cContactRelation;
            ContactPhone = cContactPhone;
            ContactPhoneType = cContactPhoneType;
            ContactComment = cContactComment;
            ContactOutcome = cContactOutcome;
            NoteFormat = cNoteFormat;
            NoteText = cNoteText;
            ReasonForVisit = cReasonForVisit;
            EncounterDate = cEncounterDate;   
        }
        
    }
    
    public class epicResponseWrapper
    {
        public String EpicReferenceID;
        public String ErrorID;
        public string ErrorMessage;
        public Boolean Success;
    }
}