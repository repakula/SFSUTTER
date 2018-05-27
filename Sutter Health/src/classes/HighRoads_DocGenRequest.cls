/******************************************************************************************************************* 
     Class Name : HighRoads_DocGenRequest 
     Author     : IDC Offshore
     Date       : 9/18/2016 
     Description: This controller class is used to create New Document Generation Request Records at SSO & Opportunity Stage
     History:
     VERSION    AUTHOR              DATE        DETAIL 
     1.0        IDC-Offshore      9/18/2016     This is controller class for HighRoads_DocGenRequest page.
                                                This is used to create New Document Generation Request Records at SSO & Opportunity Stage
                                                automatically when SSO is Approved for Large Groups & Opportunity is Closed Won 
                                                for Small Groups and Individual Business
                                                Methods in this class are called from 'Update Broker', 'SSOTrigger' Triggers and HighRoads_RegeneratePageController.
*******************************************************************************************************************/
public class HighRoads_DocGenRequest {
    //Class level properties
    public static boolean isOpportunityAfterUpdate = true;
    public static boolean isOppClosedWon = true;
    public Document_Generation_Request__c docGenObj{get;set;} 
    public List<PlanWrapper> planWrapperList{get;set;}
    public Map<String,List<planWrapper>> medicalRiderMap{get;set;}
    public List<planRiderWrapper> planRiderWrapperList{get;set;}
    List<Document_Benefit_Plan__c> documentBenefitPlanList{get;set;}
    public static boolean isRegenerateDocumentRequest = false;//Variable indicating if Method is invoked from Regenerate button
    /** Constructor to get the list of Medical/Rider Plans added to Document Benefit Plan related list in Document Generation Request
     **/
    public HighRoads_DocGenRequest(Apexpages.StandardController controller){
        this.docGenObj = (Document_Generation_Request__c)controller.getRecord();
        medicalRiderMap = new Map<String,List<planWrapper>>();
        planWrapperList = new List<planWrapper>(); 
        planRiderWrapperList = new List<planRiderWrapper>();
        documentBenefitPlanList = new List<Document_Benefit_Plan__c>();
        if(docGenObj != NULL){
            /*List of document Benefit Plans related to Current Document generation request*/
            documentBenefitPlanList = [select Name,Rider_Plan_Name__c,Plan_Type__c,Benefit_Plan_ID__c,EOC__c,SBC__c,BCM__c,AncillaryEOC__c,
                                      AncillarySOB__c,AncillaryGSA__c from Document_Benefit_Plan__c where Document_Generation_Request__c=:docGenObj.Id];
            if(!documentBenefitPlanList.isEmpty()){
                {
                    for(Document_Benefit_Plan__c docBenefitPlanObj : documentBenefitPlanList){
                        
                    //constructing medicalRiderMap to store the medical plan and its associated rider plans
                    if(medicalRiderMap.containsKey(docBenefitPlanObj.Name)){
                                List<planWrapper> mapValues = medicalRiderMap.get(docBenefitPlanObj.Name);
                                mapValues.add(new planWrapper(docBenefitPlanObj));
                                medicalRiderMap.put(docBenefitPlanObj.Name, mapValues);   
                            }else{
                                List<planWrapper> mapValues = new List<planWrapper>();
                                mapValues.add(new planWrapper(docBenefitPlanObj));
                                medicalRiderMap.put(docBenefitPlanObj.Name, mapValues);
                            }
                        
                    }
                    // construcint the planRiderWrapperList which will render in related plans inline VF page of Document generation request
                    for(String medicalPlan : medicalRiderMap.keySet()){
                        planRiderWrapperList.add(new planRiderWrapper(medicalPlan,medicalRiderMap.get(medicalPlan)));
                    }
                }
            }
        }
    }
    
    /**
     * Method Name : insertDocGenRequests
     * Parameters  : ssoIds - Set of the RecordIds of SSO
     * Description : To Create new Document Generation Request Record related to SSO Id provided
     * Return type : void
     **/
    public static void insertDocGenRequests(Set<ID> ssoIds){
        System.Savepoint savePointObj = Database.setSavepoint();
        try{
            //Map to store Corresponding SSOId for each Document Benefit Plan in list
            Map<String,List<Document_Benefit_Plan__c>> ssoIDListDocPlansMap = new Map<String,List<Document_Benefit_Plan__c>>();
            //List to store Document Benefit Plan that need to be inserted
            List<Document_Benefit_Plan__c> insertDocBenefitPlanList = new List<Document_Benefit_Plan__c>();
            BusinessHours busHours=[select id from BusinessHours where Name=: System.label.HR138_SHPBusinessHours limit 1];
            Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
            Group Queue = [select Id from Group where Name =: System.label.HR112_BenefitPlanAdminQueue and Type =: System.Label.HR143_Queue limit 1];
            //List to store Document Generation Request that need to be inserted
            List<Document_Generation_Request__c> docGenReqList = new List<Document_Generation_Request__c>();
             //List to fetch the Benefit Plan Association attributes related to SSO
            List<Sold_Sign_Off__c> ssoList = [select id,Quote__r.RFP_Form__r.Opportunity__c,Quote__r.RFP_Form__r.Opportunity__r.AccountId,Quote__r.RFP_Form__r.Opportunity__r.Account.SFDC_Account_ID__c,Employer_Type__c,
                                              Quote__r.RFP_Form__r.Opportunity__r.Account_RecordType_Name__c, Quote__r.RFP_Form__r.Opportunity__r.Account.Account_Manager__r.Id,
                                              Quote__r.RFP_Form__r.Opportunity__r.Account.Account_Executive__r.Id,
                                              (select id, name, Benefit_Plan_Metadata__r.Name, Raider_ID__r.Benefit_Plan_ID__c, Benefit_Plan_Metadata__r.Benefit_Plan_ID__c,
                                               Benefit_Plan_Metadata__r.Effective_Date__c, Raider_ID__r.Effective_Date__c,Benefit_Plan_Metadata__r.id,SSO_Benefit_Version__c,Benefit_Plan_Metadata__r.Plan_Name__c, Raider_ID__r.Plan_Name__c,Version_Number__c,
                                               Raider_ID__r.Name, Raider_ID__r.Id, Sold_Case_Notification__c,Plan_Year__c,
                                               Benefit_Plan_Metadata__r.Product_Class__c, Raider_ID__r.Product_Class__c, Medical_or_Rider__c,
                                               Benefit_Plan_Metadata__r.Plan_Type__c, Raider_ID__r.Plan_Type__c,
                                               Benefit_Plan_Metadata__r.EOC__c, Benefit_Plan_Metadata__r.SBC__c,
                                               Benefit_Plan_Metadata__r.BCM__c, Benefit_Plan_Metadata__r.Ancillary_EOC__c,
                                               Benefit_Plan_Metadata__r.Ancillary_SOB__c, Benefit_Plan_Metadata__r.Ancillary_GSA__c,
                                               Raider_ID__r.EOC__c, Raider_ID__r.SBC__c,
                                               Raider_ID__r.BCM__c, Raider_ID__r.Ancillary_EOC__c,
                                               Raider_ID__r.Ancillary_SOB__c, Raider_ID__r.Ancillary_GSA__c,Benefit_Plan_Metadata__r.planTypeAlternate__c,
                                              Benefit_Plan_Metadata__r.isHDHP__c,Benefit_Plan_Metadata__r.IsCustom__c,
                                              Benefit_Plan_Metadata__r.End_Date__c,Raider_ID__r.End_Date__c,Raider_ID__r.planTypeAlternate__c,
                                              Raider_ID__r.isHDHP__c,Raider_ID__r.IsCustom__c
                                               FROM Benefit_Plan_Associations__r) from Sold_Sign_Off__c 
                                              where ID IN :ssoIds];
            
            for(Sold_Sign_Off__c sso : ssoList){
                Document_Generation_Request__c docGenObj = new Document_Generation_Request__c();
                List<Document_Benefit_Plan__c> tempDocBenefitPlanList = new List<Document_Benefit_Plan__c>();
                Integer docRequestCount = 0;//Variable to store Count of Documents checked for all the Plans in Document Generation Request
                /*Populate Account Type based on the record Type & Employer Type of Related Account from Custom Setting*/
                if(groups.get(sso.Employer_Type__c) != NULL){
                    docGenObj.Account_Type__c = groups.get(sso.Employer_Type__c).P2A_Market_Segment__c;     
                }else if(sso.Quote__r.RFP_Form__r.Opportunity__r.Account_RecordType_Name__c != NULL && sso.Quote__r.RFP_Form__r.Opportunity__r.Account_RecordType_Name__c.equalsIgnoreCase(System.Label.HR80_SHPSalesIndividual)){
                    docGenObj.Account_Type__c = System.Label.HR80_SHPSalesIndividual;           
                }else if(sso.Quote__r.RFP_Form__r.Opportunity__r.Account_RecordType_Name__c != NULL && sso.Employer_Type__c == NULL && sso.Quote__r.RFP_Form__r.Opportunity__r.Account_RecordType_Name__c.equalsIgnoreCase(System.Label.HR53_AccountRecordTypeName)){
                    docGenObj.Account_Type__c = System.label.HR142_Unclassified;    
                }
                //Create document Benefit Plan for each benefit plan association record related to SSO 
                for(Benefit_Plan_Association__c bpa : sso.Benefit_Plan_Associations__r){
                    Document_Benefit_Plan__c documentBenefitPlanObj = new Document_Benefit_Plan__c();
                    String SFDCId = sso.Quote__r.RFP_Form__r.Opportunity__r.Account.SFDC_Account_ID__c;
                    if((bpa.Medical_or_Rider__c == System.Label.HR42_Medical) && (bpa.Benefit_Plan_Metadata__r.Plan_Type__c.equalsIgnoreCase(System.label.HR49_Custom))){
                        docGenObj.has_Custom_Plans__c = True;
                    }else if((bpa.Medical_or_Rider__c == System.Label.HR43_Rider) && (bpa.Raider_ID__r.Plan_Type__c.equalsIgnoreCase(System.label.HR49_Custom))){
                        docGenObj.has_Custom_Plans__c = True;  
                    }
                    /*Populate Document Name values in Document Types checked,Plan details for Medical Plan by calling method*/
                    Map<Document_Benefit_Plan__c,Integer> returnMap = GenDocNames(bpa,documentBenefitPlanObj,bpa.Medical_or_Rider__c,docGenObj,SFDCId,docRequestCount,HighRoads_Constants.SSOOBJNAME);
                    List<Integer> countList = returnMap.values();
                    docRequestCount = countList[0];
                    List<Document_Benefit_Plan__c> docPlanObj = new List<Document_Benefit_Plan__c>(returnMap.keySet());//returnMap.keySet();
                    documentBenefitPlanObj = docPlanObj[0]; 
                    tempDocBenefitPlanList.add(documentBenefitPlanObj);
                }
                /*Auto-populate Information in Document Generation Request from related Account & Opportunity*/ 
                if(docGenObj.has_Custom_Plans__c == True){
                    docGenObj.Request_Due_Date__c = Null;      
                }else{
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,system.today(),97200000));
                }
                docGenObj.Requestor__c = UserInfo.getUserId();
                docGenObj.Related_Object_Id__c = sso.Id;
                docGenObj.Account__c = sso.Quote__r.RFP_Form__r.Opportunity__r.AccountId;
                docGenObj.Opportunity__c = sso.Quote__r.RFP_Form__r.Opportunity__c;
                docGenObj.Sold_Sign_Off__c = sso.Id;
                docGenObj.of_Documents_Requested__c = docRequestCount;
                docGenObj.Account_Manager__c = sso.Quote__r.RFP_Form__r.Opportunity__r.Account.Account_Manager__r.Id;
                docGenObj.Account_Executive__c = sso.Quote__r.RFP_Form__r.Opportunity__r.Account.Account_Executive__r.Id;
                docGenObj.OwnerId = Queue.Id;
                docGenReqList.add(docGenObj);
                ssoIDListDocPlansMap.put(sso.Id,tempDocBenefitPlanList);
            }
            /*Insert Document Generation Request*/
            if(!docGenReqList.isEmpty()){
                Database.insert(docGenReqList);
            }
            /*Insert Document Benefit Plans for Benefit Plan Associations in related SSO for new Document Generation Request*/
            for(Document_Generation_Request__c docGenObj : docGenReqList){
                for(Document_Benefit_Plan__c docBenefitPlanObj : ssoIDListDocPlansMap.get(docGenObj.Sold_Sign_Off__c)){
                    docBenefitPlanObj.Document_Generation_Request__c = docGenObj.Id;
                    insertDocBenefitPlanList.add(docBenefitPlanObj);
                }
            }
            if(insertDocBenefitPlanList != NULL && !insertDocBenefitPlanList.isEmpty()){
                Insert insertDocBenefitPlanList;
            }
        }catch(Exception ex){Database.rollback(savePointObj);System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
    }
    
    /**
     * Method Name : insertDocGenRequestsOpp
     * Parameters  : oppIds - Set of the RecordIds of Opportunity
     * Description : To Create new Document Generation Request Record related to Opportunity Id provided
     * Return type : void
     **/
    public static void insertDocGenRequestsOpp(Set<ID> oppIds){
        System.Savepoint savePointObj = Database.setSavepoint();
        List<Opportunity> updateOppList = new List<Opportunity>();
        System.debug('inside doc gen'+oppIds);
        //try{
            for(ID oppId : oppIds){
                Opportunity opp = new Opportunity(id=oppId);
                opp.regenerate__c = true;
                updateOppList.add(opp);
            }
            if(updateOppList != NULL && !updateOppList.isEmpty()){
                update updateOppList;
            }
            String relatedPlans;//variable to store Plan names of Medical/Rider Plans related to Opportunity
            //Map to store Corresponding SSOId for each Document Benefit Plan in list
            Map<String,List<Document_Benefit_Plan__c>> oppIDListDocPlansMap = new Map<String,List<Document_Benefit_Plan__c>>();
            //List to store Document Benefit Plan that need to be inserted
            List<Document_Benefit_Plan__c> insertDocBenefitPlanList = new List<Document_Benefit_Plan__c>();
            Group Queue = [select Id from Group where Name =: System.label.HR112_BenefitPlanAdminQueue and Type =: System.Label.HR143_Queue limit 1];
            Group salesQueue = [select Id from Group where Name =: System.label.HR78_SHP_Sales_Queue and Type =: System.Label.HR143_Queue limit 1];
            BusinessHours busHours=[select id from BusinessHours where Name=: System.label.HR138_SHPBusinessHours limit 1];
            Map<String,SF_P2A_Market_Segments_Mapping__c> groups = SF_P2A_Market_Segments_Mapping__c.getAll();
            //List to store Document Generation Request that need to be inserted
            List<Document_Generation_Request__c> docGenReqList = new List<Document_Generation_Request__c>();
            //List to store existing Document Generation Request that is associated to Opportuity
            List<Document_Generation_Request__c> preDocReqList = new List<Document_Generation_Request__c>();
            Map<String,String> oppDocGenAutoNumberMap = new Map<String,String>();
            //List to fetch the Benefit Plan Association, existing Document Generation Request attributes related to Opportunity
            List<Opportunity> oppList = [select id, Account.Name,AccountID,Name,Employer_Type__c,Account_RecordType_Name__c,
                                         Account.Account_Manager__r.Id, Account.Account_Executive__r.Id,Account.SFDC_Account_ID__c,
                                         (select id, name, Benefit_Plan_Metadata__r.Name, Benefit_Plan_Metadata__r.id,
                                          Raider_ID__r.Name, Raider_ID__r.Id, Sold_Case_Notification__c,Version_Number__c,Plan_Year__c,
                                          Benefit_Plan_Metadata__r.Product_Class__c, Raider_ID__r.Product_Class__c, Medical_or_Rider__c,
                                          Benefit_Plan_Metadata__r.Plan_Type__c, Raider_ID__r.Plan_Type__c,Raider_ID__r.Benefit_Plan_ID__c, 
                                          Benefit_Plan_Metadata__r.Benefit_Plan_ID__c,Benefit_Plan_Metadata__r.Effective_Date__c, Raider_ID__r.Effective_Date__c,
                                          Benefit_Plan_Metadata__r.EOC__c, Benefit_Plan_Metadata__r.SBC__c,
                                          Benefit_Plan_Metadata__r.BCM__c, Benefit_Plan_Metadata__r.Ancillary_EOC__c,
                                          Benefit_Plan_Metadata__r.Ancillary_SOB__c, Benefit_Plan_Metadata__r.Ancillary_GSA__c,
                                          Raider_ID__r.EOC__c, Raider_ID__r.SBC__c,Opportunity__r.Account.SFDC_Account_ID__c,
                                          Raider_ID__r.BCM__c, Raider_ID__r.Ancillary_EOC__c,
                                          Raider_ID__r.Ancillary_SOB__c, Raider_ID__r.Ancillary_GSA__c,
                                          Raider_ID__r.Unique_ID__c, Benefit_Plan_Metadata__r.Unique_ID__c,
                                          Benefit_Plan_Metadata__r.Plan_Name__c,Benefit_Plan_Metadata__r.planTypeAlternate__c,
                                          Benefit_Plan_Metadata__r.isHDHP__c,Benefit_Plan_Metadata__r.IsCustom__c,
                                          Benefit_Plan_Metadata__r.End_Date__c,Raider_ID__r.End_Date__c,
                                          Raider_ID__r.Plan_Name__c,Raider_ID__r.planTypeAlternate__c,
                                          Raider_ID__r.isHDHP__c,Raider_ID__r.IsCustom__c
                                          FROM Benefit_Plan_Associations__r),
                                         (select id,name,Request_Status__c,OwnerId FROM Document_Generation_Requests__r 
                                          Where Request_Status__c !=: System.label.HR140_Approved order by createddate desc limit 1)
                                         from Opportunity where ID IN :oppIds];
            for(Opportunity opp : oppList){
                Document_Generation_Request__c docGenObj = new Document_Generation_Request__c();
                List<Document_Benefit_Plan__c> tempDocBenefitPlanList = new List<Document_Benefit_Plan__c>();
                Integer docRequestCount = 0;//Variable to store Count of Documents checked for all the Plans in Document Generation Request
                /*Populate Account Type based on the record Type & Employer Type of Related Account from Custom Setting*/
                if(groups.get(opp.Employer_Type__c) != NULL){
                    docGenObj.Account_Type__c = groups.get(opp.Employer_Type__c).P2A_Market_Segment__c;     
                }else if(opp.Account_RecordType_Name__c != NULL && opp.Account_RecordType_Name__c.equalsIgnoreCase(System.Label.HR80_SHPSalesIndividual)){
                    docGenObj.Account_Type__c = System.Label.HR80_SHPSalesIndividual;           
                }else if(opp.Account_RecordType_Name__c != NULL && opp.Employer_Type__c == NULL && opp.Account_RecordType_Name__c.equalsIgnoreCase(System.Label.HR53_AccountRecordTypeName)){
                    docGenObj.Account_Type__c = System.label.HR142_Unclassified;    
                }
                //Create document Benefit Plan for each benefit plan association record related to Opportunity 
                for(Benefit_Plan_Association__c bpa : opp.Benefit_Plan_Associations__r){
                    system.debug('insdie bpa loop'+bpa.Medical_or_Rider__c);
                    Document_Benefit_Plan__c documentBenefitPlanObj = new Document_Benefit_Plan__c();
                    String SFDCId = opp.Account.SFDC_Account_ID__c;
                    /*Populate Document Name values in Document Types checked, Plan details for Medical Plan*/
                    if(bpa.Medical_or_Rider__c == System.Label.HR42_Medical){
                        if(relatedPlans != Null){
                            relatedPlans = relatedPlans+','+bpa.Benefit_Plan_Metadata__r.Unique_ID__c;
                        }else{
                            relatedPlans = bpa.Benefit_Plan_Metadata__r.Unique_ID__c;
                        }
                        
                        if(bpa.Benefit_Plan_Metadata__r.Plan_Type__c.equalsIgnoreCase(System.label.HR49_Custom)){
                            docGenObj.has_Custom_Plans__c = True;  
                        }
                    }else if(bpa.Medical_or_Rider__c == System.Label.HR43_Rider){
                        if(relatedPlans != Null){
                            relatedPlans = relatedPlans+','+bpa.Raider_ID__r.Unique_ID__c+'-'+bpa.Benefit_Plan_Metadata__r.Unique_ID__c;
                        }else{
                            relatedPlans = bpa.Raider_ID__r.Unique_ID__c+'-'+bpa.Benefit_Plan_Metadata__r.Unique_ID__c;   
                        }
                        if(bpa.Raider_ID__r.Plan_Type__c.equalsIgnoreCase(System.label.HR49_Custom)){
                            docGenObj.has_Custom_Plans__c = True;  
                        }
                    }
                    /*Populate Document Name values in Document Types checked,Plan details for Medical Plan by calling method*/
                    Map<Document_Benefit_Plan__c,Integer> returnMap = GenDocNames(bpa,documentBenefitPlanObj,bpa.Medical_or_Rider__c,docGenObj,SFDCId,docRequestCount,HighRoads_Constants.OPPOBJNAME);
                    List<Integer> countList = returnMap.values();
                    docRequestCount = countList[0];
                    List<Document_Benefit_Plan__c> docPlanObj1 = new List<Document_Benefit_Plan__c>(returnMap.keySet());//returnMap.keySet();
                    documentBenefitPlanObj = docPlanObj1[0]; 
                    tempDocBenefitPlanList.add(documentBenefitPlanObj);
                }
                /*Auto-populate Information in Document Generation Request from related Account & Opportunity*/ 
                if(docGenObj.has_Custom_Plans__c == True){
                    docGenObj.Request_Due_Date__c = Null;     
                }else{
                    docGenObj.Request_Due_Date__c = Date.valueOf(BusinessHours.add(busHours.id,system.today(),97200000));
                }
                docGenObj.Requestor__c = UserInfo.getUserId();
                docGenObj.Related_Object_Id__c = opp.Id;
                docGenObj.Account__c = opp.AccountID;
                docGenObj.Opportunity__c = opp.Id;
                docGenObj.of_Documents_Requested__c = docRequestCount;
                docGenObj.plans__c = relatedPlans;
                docGenObj.Account_Manager__c = opp.Account.Account_Manager__r.Id;
                docGenObj.Account_Executive__c = opp.Account.Account_Executive__r.Id;
                docGenObj.OwnerId = Queue.Id;
                docGenReqList.add(docGenObj);
                oppIDListDocPlansMap.put(opp.Id,tempDocBenefitPlanList);
            }
            /*Insert Document Generation Request*/
            if(docGenReqList !=NULL && !docGenReqList.isEmpty()){
                Database.insert(docGenReqList);
            }   
            for(Document_Generation_Request__c dgrObj : [select Id,Name,Opportunity__c from Document_Generation_Request__c where Id IN :docGenReqList]){
                oppDocGenAutoNumberMap.put(dgrObj.Opportunity__c, dgrObj.Name);
            }
            /*Change Status of Previous Document Generation Request & change Ownwer to SHP Sales Queue 
            when New Request is Created due to Plan selection Change in Opportunity*/
            if(!isRegenerateDocumentRequest){
                for(Opportunity opp : oppList){
                    for(Document_Generation_Request__c preDocGen : opp.Document_Generation_Requests__r){
                        preDocGen.Request_Status__c  = System.label.HR174_PlanSelectionChanged +oppDocGenAutoNumberMap.get(opp.Id);     
                        preDocGen.OwnerId = salesQueue.Id;
                        preDocReqList.add(preDocGen);
                    }    
                }
            }
            /*Insert Document Benefit Plans for Benefit Plan Associations in related SSO for new Document Generation Request*/
            for(Document_Generation_Request__c docGenObj : docGenReqList){
                for(Document_Benefit_Plan__c docBenefitPlanObj : oppIDListDocPlansMap.get(docGenObj.Opportunity__c)){
                    docBenefitPlanObj.Document_Generation_Request__c = docGenObj.Id;
                    insertDocBenefitPlanList.add(docBenefitPlanObj);
                }
            }
            if(insertDocBenefitPlanList != NULL && !insertDocBenefitPlanList.isEmpty()){
                Insert insertDocBenefitPlanList;
            }
            /*Update Existing recent Document Generation Request*/
            if(preDocReqList !=NULL && !preDocReqList.isEmpty()){
                update preDocReqList;
            }
            if(updateOppList != NULL && !updateOppList.isEmpty()){
                List<Opportunity> reOppUpdateList = new List<Opportunity>();
                for(Opportunity opp : updateOppList){
                    opp.regenerate__c = false;
                    reOppUpdateList.add(opp);
                }
                update reOppUpdateList;
            }
        //}catch(Exception ex){Database.rollback(savePointObj);System.debug(ex.getTypeName() + HighRoads_Constants.HYPHEN + ex.getCause() + HighRoads_Constants.COLON + ex.getMessage());}
    }
    
    /**
    * Class Name  : planWrapper
    * Description : Wrapper Class to Construct Medical Plan list for Document Generation Request
    **/
    public class planWrapper{
        public string Name{get;set;}
        public string planName{get;set;}
        public string riderName{get;set;}
        public String EOC{get;set;}
        public String benefitId{get;set;}
        public String SBC{get;set;}
        public String BCM{get;set;}
        public String ancillaryEOC{get;set;}
        public String ancillarySOB{get;set;}
        public String ancillaryGSA{get;set;}
        public planWrapper(Document_Benefit_Plan__c docBenefitPlanObj){
            this.Name = docBenefitPlanObj.Plan_Type__c;
            this.planName = docBenefitPlanObj.name;
            this.riderName = docBenefitPlanObj.Rider_Plan_Name__c;
            this.benefitId = docBenefitPlanObj.Benefit_Plan_ID__c;
            this.EOC = docBenefitPlanObj.EOC__c; 
            this.SBC = docBenefitPlanObj.SBC__c; 
            this.BCM = docBenefitPlanObj.BCM__c;
            this.ancillaryEOC = docBenefitPlanObj.AncillaryEOC__c;
            this.ancillarySOB = docBenefitPlanObj.AncillarySOB__c;
            this.ancillaryGSA = docBenefitPlanObj.AncillaryGSA__c;
        }
    }
    
    /**
    * Class Name  : planRiderWrapper
    * Description : Wrapper Class to Construct Rider Plan list for each Medical Plan in Document Generation Request
    **/
    public class planRiderWrapper{
        public string Name{get;set;}
        public List<planWrapper> planWrapperList{get;set;}
        public Integer sizeOfPlanWrappers{get;set;}
        public planRiderWrapper(String Name,List<planWrapper> planWrapList){
            this.Name = Name;
            this.planWrapperList = planWrapList;
            this.sizeOfPlanWrappers = planWrapList.size()+1;
        }
    }
    
    /**
    * Method Name : exportFiles
    * Parameters  : None
    * Description : Excel File with Documents is downloaded when click on "Export File Names" button in HighRoads_DocGenReq.Page
    * Return type : PageReference 
    **/
    public PageReference exportFiles(){
       return page.HighRoads_DocGenRequestExport;
    }
    
    /**
    * Method Name : GenDocNames
    * Parameters  : Benefit_Plan_Association__c,Document_Benefit_Plan__c,medicalorrider, Document_Generation_Request,SFDCId,docRequestCount
    * Description : Helper method to generate document names for each associated Benefit Plan Association
    * Return type : Map<Document_Benefit_Plan__c,Integer> 
    **/
    public static Map<Document_Benefit_Plan__c,Integer> GenDocNames(Benefit_Plan_Association__c bpa,Document_Benefit_Plan__c documentBenefitPlanObj,String medicalorrider, Document_Generation_Request__c docGenObj,String SFDCId,Integer docRequestCount,String objName){
 
        Integer benefitversion ;
        if(objName.equalsIgnoreCase(HighRoads_Constants.SSOOBJNAME)){
            benefitversion = Integer.valueOf(bpa.SSO_Benefit_Version__c);
        }else{
            benefitversion = Integer.valueOf(bpa.Version_Number__c);
        }
        String year = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? (bpa.Benefit_Plan_Metadata__r.Effective_Date__c != NULL ? string.valueOf(bpa.Benefit_Plan_Metadata__r.Effective_Date__c.year()) : NULL ) : (bpa.Raider_ID__r.Effective_Date__c != NULL ? string.valueOf(bpa.Raider_ID__r.Effective_Date__c.year()) : NULL);
		String month = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? (bpa.Benefit_Plan_Metadata__r.Effective_Date__c != NULL ? string.valueOf(bpa.Benefit_Plan_Metadata__r.Effective_Date__c.month()) : NULL) : (bpa.Raider_ID__r.Effective_Date__c != NULL ? string.valueOf(bpa.Raider_ID__r.Effective_Date__c.month()) : NULL);
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.EOC__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.EOC__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.EOC__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+SFDCId+System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR167_EOC+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+SFDCId+System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR167_EOC+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.SBC__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.SBC__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.SBC__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR168_SBC+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR168_SBC+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.BCM__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.BCM__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.BCM__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR169_BCM+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR169_BCM+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.Ancillary_EOC__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.Ancillary_EOC__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.AncillaryEOC__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR170_AncillaryEOC+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR170_AncillaryEOC+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.Ancillary_SOB__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.Ancillary_SOB__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.AncillarySOB__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR171_AncillarySOB+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR171_AncillarySOB+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        
        if((medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) && bpa.Benefit_Plan_Metadata__r.Ancillary_GSA__c) || (medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) && bpa.Raider_ID__r.Ancillary_GSA__c)){
		docRequestCount += 1;    
		documentBenefitPlanObj.AncillaryGSA__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? 
                                            (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                            bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c+System.label.HR172_AncillaryGSA+year+System.label.HR166_Underscore+
                                            month+System.label.HR166_Underscore+benefitversion+System.label.HR173_00_pdf) : 
                                                (docGenObj.Account_Type__c+System.label.HR166_Underscore+ SFDCId +System.label.HR166_Underscore+
                                                 bpa.Raider_ID__r.Benefit_Plan_ID__c+System.label.HR172_AncillaryGSA+year+System.label.HR166_Underscore+month+System.label.HR166_Underscore+
                                                 benefitversion+System.label.HR173_00_pdf);
		}
        documentBenefitPlanObj.Benefit_Version__c = benefitversion;
        documentBenefitPlanObj.Name = bpa.Benefit_Plan_Metadata__r.Name ;
        documentBenefitPlanObj.Plan_year__c = bpa.Plan_Year__c;
        documentBenefitPlanObj.Rider_Plan_Name__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.RIDER) ? bpa.Raider_ID__r.Name : NULL;
        documentBenefitPlanObj.Plan_Type__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.Product_Class__c : bpa.Raider_ID__r.Product_Class__c;
        documentBenefitPlanObj.Benefit_Plan_ID__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.Benefit_Plan_ID__c :bpa.Raider_ID__r.Benefit_Plan_ID__c;
        documentBenefitPlanObj.Plan_Name__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ?  bpa.Benefit_Plan_Metadata__r.Plan_Name__c : bpa.Raider_ID__r.Plan_Name__c;
        documentBenefitPlanObj.Plan_Name_Alternate__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.planTypeAlternate__c : bpa.Raider_ID__r.planTypeAlternate__c;
        documentBenefitPlanObj.Plan_IsHDHP__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.isHDHP__c : bpa.Raider_ID__r.isHDHP__c;
        documentBenefitPlanObj.Plan_IsCustom__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.IsCustom__c : bpa.Raider_ID__r.IsCustom__c;
        documentBenefitPlanObj.Plan_Start_Date__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.Effective_Date__c : bpa.Raider_ID__r.Effective_Date__c;
        documentBenefitPlanObj.Plan_End_Date__c = medicalorrider.equalsIgnoreCase(HighRoads_Constants.MEDICAL) ? bpa.Benefit_Plan_Metadata__r.End_Date__c : bpa.Raider_ID__r.End_Date__c;
        documentBenefitPlanObj.Plan_ID_SFDC__c = bpa.id;
        Map<Document_Benefit_Plan__c,Integer> returnValue= new Map<Document_Benefit_Plan__c,Integer>();
        returnValue.put(documentBenefitPlanObj,docRequestCount);
        return returnValue;
    }
}