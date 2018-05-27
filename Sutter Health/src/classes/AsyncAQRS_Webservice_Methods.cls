//Generated by wsdl2apex

public class AsyncAQRS_Webservice_Methods {
    public class GetPatientListByPVPResponse_elementFuture extends System.WebServiceCalloutFuture {
        public AQRS_WSSchema_Details.PatientListPVPReturnData getValue() {
            AQRS_Webservice_Methods.GetPatientListByPVPResponse_element response = (AQRS_Webservice_Methods.GetPatientListByPVPResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetPatientListByPVPResult;
        }
    }
    public class GetProviderAttrInfoResponse_elementFuture extends System.WebServiceCalloutFuture {
        public AQRS_WSSchema_Details.ProviderAttrReturnData getValue() {
            AQRS_Webservice_Methods.GetProviderAttrInfoResponse_element response = (AQRS_Webservice_Methods.GetProviderAttrInfoResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetProviderAttrInfoResult;
        }
    }
    public class GetPatientDetailsByMRNResponse_elementFuture extends System.WebServiceCalloutFuture {
        public AQRS_WSSchema_Details.PatientDetGICAndPVPReturnData getValue() {
            AQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_element response = (AQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetPatientDetailsByMRNResult;
        }
    }
    public class GetPatientListByGICResponse_elementFuture extends System.WebServiceCalloutFuture {
        public AQRS_WSSchema_Details.PatientListGICReturnData getValue() {
            AQRS_Webservice_Methods.GetPatientListByGICResponse_element response = (AQRS_Webservice_Methods.GetPatientListByGICResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetPatientListByGICResult;
        }
    }
    public class AsyncBasicHttpBinding_ISutterService {
        public String endpoint_x = 'http://219.65.97.99/AQRS_CRM_Service/SutterSvc.svc/soapbasic';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'AQRS_Webservice_Methods', 'http://schemas.datacontract.org/2004/07/WcfSutterService', 'AQRS_WSSchema_Details', 'http://schemas.microsoft.com/2003/10/Serialization/', 'schemasMicrosoftCom200310Serializat'};
        public AsyncAQRS_Webservice_Methods.GetPatientListByPVPResponse_elementFuture beginGetPatientListByPVP(System.Continuation continuation,Integer intPageNumber,AQRS_WSSchema_Details.PatientListGICPVPInputData objPatientListGICPVPInput,String strUserName) {
            AQRS_Webservice_Methods.GetPatientListByPVP_element request_x = new AQRS_Webservice_Methods.GetPatientListByPVP_element();
            request_x.intPageNumber = intPageNumber;
            request_x.objPatientListGICPVPInput = objPatientListGICPVPInput;
            request_x.strUserName = strUserName;
            return (AsyncAQRS_Webservice_Methods.GetPatientListByPVPResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncAQRS_Webservice_Methods.GetPatientListByPVPResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/ISutterService/GetPatientListByPVP',
              'http://tempuri.org/',
              'GetPatientListByPVP',
              'http://tempuri.org/',
              'GetPatientListByPVPResponse',
              'AQRS_Webservice_Methods.GetPatientListByPVPResponse_element'}
            );
        }
        public AsyncAQRS_Webservice_Methods.GetProviderAttrInfoResponse_elementFuture beginGetProviderAttrInfo(System.Continuation continuation,Integer intPageNumber,String strUserName) {
            AQRS_Webservice_Methods.GetProviderAttrInfo_element request_x = new AQRS_Webservice_Methods.GetProviderAttrInfo_element();
            request_x.intPageNumber = intPageNumber;
            request_x.strUserName = strUserName;
            return (AsyncAQRS_Webservice_Methods.GetProviderAttrInfoResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncAQRS_Webservice_Methods.GetProviderAttrInfoResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/ISutterService/GetProviderAttrInfo',
              'http://tempuri.org/',
              'GetProviderAttrInfo',
              'http://tempuri.org/',
              'GetProviderAttrInfoResponse',
              'AQRS_Webservice_Methods.GetProviderAttrInfoResponse_element'}
            );
        }
        public AsyncAQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_elementFuture beginGetPatientDetailsByMRN(System.Continuation continuation,Integer intPageNumber,String strPatientMRN,String strUserName) {
            AQRS_Webservice_Methods.GetPatientDetailsByMRN_element request_x = new AQRS_Webservice_Methods.GetPatientDetailsByMRN_element();
            request_x.intPageNumber = intPageNumber;
            request_x.strPatientMRN = strPatientMRN;
            request_x.strUserName = strUserName;
            return (AsyncAQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncAQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/ISutterService/GetPatientDetailsByMRN',
              'http://tempuri.org/',
              'GetPatientDetailsByMRN',
              'http://tempuri.org/',
              'GetPatientDetailsByMRNResponse',
              'AQRS_Webservice_Methods.GetPatientDetailsByMRNResponse_element'}
            );
        }
        public AsyncAQRS_Webservice_Methods.GetPatientListByGICResponse_elementFuture beginGetPatientListByGIC(System.Continuation continuation,Integer intPageNumber,AQRS_WSSchema_Details.PatientListGICPVPInputData objPatientListGICPVPInput,String strUserName) {
            AQRS_Webservice_Methods.GetPatientListByGIC_element request_x = new AQRS_Webservice_Methods.GetPatientListByGIC_element();
            request_x.intPageNumber = intPageNumber;
            request_x.objPatientListGICPVPInput = objPatientListGICPVPInput;
            request_x.strUserName = strUserName;
            return (AsyncAQRS_Webservice_Methods.GetPatientListByGICResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncAQRS_Webservice_Methods.GetPatientListByGICResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/ISutterService/GetPatientListByGIC',
              'http://tempuri.org/',
              'GetPatientListByGIC',
              'http://tempuri.org/',
              'GetPatientListByGICResponse',
              'AQRS_Webservice_Methods.GetPatientListByGICResponse_element'}
            );
        }
    }
}