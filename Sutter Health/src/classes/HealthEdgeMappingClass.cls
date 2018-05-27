/**  
*    Class Name: HealthEdgeMappingClass
*    Author: Eric Pellish/Offshore
*    Date: 20-November-2013
*    Description: This class is used to map the Claim Detail response received from the HealthEdge Server and paginate the claim line items
*    History
*    --------
**/

global class HealthEdgeMappingClass{ 

    public String contents;
    public String HCCSample;
    public claim_line_item claim_line_item;
    public boolean showError; 
       
    public void setShowError(Boolean error){
        showError = error; 
        }
    public boolean getShowError(){
        System.debug('@@ShowError in getter method' + showError); 
        return showError; 
        }
        
    public healthEdgeComExtract.extractPayload extractPayload = new healthEdgeComExtract.extractPayload(); 
    public healthEdgeComExtract.EOBPaymentInformation EOBPaymentInformation = new healthEdgeComExtract.EOBPaymentInformation();
    public healthEdgeComExtract.payer payer = new healthEdgeComExtract.payer();
    public healthEdgeComExtract.claim claim = new healthEdgeComExtract.claim();
    public List<claim_line_item> TotalClaimLineItemList {get;set;}
    List<claim_line_item> claimLineReturnList = new List<claim_line_item>();
    
    /**
    *   @Description: This method requests the extract claim detail from HealthEdge based upon input parameters from the claim page
    *   @Arguments: String for HCCID, Integer for Increment, Integer for PageSize, Integer for PageNumber
    *   @Return: Void
    **/

public void requestResponseStub(String HCCID, Integer Increment, Integer PageSize, Integer PageNumber) {
        
        List<claim_line_item> paginatedClaimList= new List<claim_line_item>();
        List<claim_line_item> listclaim = new List<claim_line_item>(); 
        healthedgeCom_6.ClaimServiceStronglyTypedTypePort stub = new healthedgeCom_6.ClaimServiceStronglyTypedTypePort();
        String myData = System.label.CL41_ClaimUnamePassword; //'integration-crm:IntegrationCRMFNxC=$22';
        String encodedusernameandpassword = EncodingUtil.base64Encode(Blob.valueOf(myData));
        system.debug('encodedusernameandpassword :: '+encodedusernameandpassword);
        stub.inputHttpHeaders_x = new Map<String, String>();
        stub.inputHttpHeaders_x.put('Authorization','Basic ' + encodedusernameandpassword );
        stub.inputHttpHeaders_x.put('Charset','UTF-8');
        stub.inputHttpHeaders_x.put('Content-Type','text/xml');
        system.debug('stub.inputHttpHeaders_x ::'+stub.inputHttpHeaders_x);
        
        healthedgeCom_6.claimDetailFlags claimDetailFlags = new healthedgeCom_6.claimDetailFlags();
        healthedgeCom_6.claimFilterParameters claimFilterParameters = new healthedgeCom_6.claimFilterParameters();
        claimDetailFlags.includeAccounts = true;
        claimDetailFlags.includeAccumulators = true;
        claimDetailFlags.includeBenefitPlan = true;
        claimDetailFlags.includeBenefitNetwork = true;
        claimDetailFlags.includeExternalRepricerResult = true; 
        claimDetailFlags.includeFundedAccounts = true;
        claimDetailFlags.includeIngenixExternalLineResult = true;
        claimDetailFlags.includePractitioner = true;
        claimDetailFlags.includeProcedureInformation = true;
        claimDetailFlags.includeProduct = true;
        claimDetailFlags.includeReportingCategories = true;
        claimDetailFlags.includeRepricerName = true;
        claimDetailFlags.includeSupplier = true;
        claimDetailFlags.includeSupplierInvoice = true;
        claimDetailFlags.includeSupplierLocation = true;
        claimDetailFlags.includeWithholding = true;
        claimFilterParameters.includeAllPreviouslyPaid = true;
        claimFilterParameters.includeReversedClaimHeader = true;

        //Requested object from HealthEdge
       // extractPayload = stub.getClaimDetailsByHccID(HCCID,claimDetailFlags,claimFilterParameters);
        system.debug('@@extractPayload outside try: '+ extractPayload);
     if (HCCID == null || HCCID == ''){
         setshowError(true); 
         }
     else
     {
     try{
         system.debug('@@extractPayload : '+ extractPayload);
         if(!Test.isRunningTest()) {
            extractPayload = stub.getClaimDetailsByHccID(HCCID,claimDetailFlags,claimFilterParameters);
            system.debug('@@extractPayload inside if: '+ extractPayload);
        }
         System.debug('@@ShowError in before if statement in request ' + showError); 
         System.debug('@@extractPayload is ' + extractPayload); 
         System.debug('HCCID from extract is ' + extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0].hccId); 
        if(extractPayload == null){
            setshowError(true);
            System.debug('@@ShowError inside if statement ' + showError); 
            listclaim = null; 
        }
        else{
            
           listclaim = setTotalClaimDetail();
           paginatedClaimList = paginateClaim(Increment, PageSize, PageNumber);       
        }

        
        }catch(System.CalloutException calloutEx)
        {
            if(calloutEx.getMessage().contains('SOAP Fault')){
            setShowError(true); 
            }
            else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, calloutEx.getMessage()));
            Utility.handleExceptionFromCode(calloutEx.getMessage() + '\r\n' + calloutEx.getStackTraceString() + '\r\n' + calloutEx.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------'); 
            }
            system.debug('@@Exception :' + calloutEx.getMessage() + '\r\n' + calloutEx.getStackTraceString() + '\r\n' + calloutEx.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }  
        catch(Exception e){
            setShowError(true); 
            System.debug('@@Exception Message: ' + e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n' + e.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');
        }
     }
    }

    /**
    *   @Description: This method steps through the ExtractPayload object response and maps it to the appropriate fields 
    *   @Arguments: None
    *   @Return: List of Claim Line Itemes
    **/
    public List<claim_line_item> setTotalClaimDetail() {
        
        TotalClaimLineItemList = new List<claim_line_item>();
        system.debug('@@extractPayload inside method: '+ extractPayload);
        List<healthedgeComExtract.EOBPaymentInformation> eList = new List<healthedgeComExtract.EOBPaymentInformation>();
        healthedgeComExtract.claim claim = new healthedgeComExtract.claim(); 
        List<healthedgeComExtract.claim> claimList = new List<healthedgeComExtract.claim>(); 
        healthedgeComExtract.claimLine claimLine = new healthedgeComExtract.claimLine(); 
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        healthedgeComExtract.lineOfBusiness lineOfBusiness = new healthedgeComExtract.lineOfBusiness(); 
        List<healthedgeComExtract.lineOfBusiness> linesOfBusiness = new List<healthedgeComExtract.lineOfBusiness>();  
        List<healthedgeComExtract.procedure> procedureList = new List<healthedgeComExtract.procedure>();
        healthedgeComExtract.procedure procedure = new healthedgeComExtract.procedure(); 
        List<healthedgeComExtract.accumulator> accumulatorList = new List<healthedgeComExtract.accumulator>();
        List<String> prConditionCodes_stringList_x = new List<String>();
        List<String> reasonForVisit_string_x = new List<String>();
        List<String> receivedAuth_string_x = new List<String>();
        Integer Listincrement = 0;  
        healthedgeComExtract.occurrenceCode occurrenceCodeList = new healthedgeComExtract.occurrenceCode();
        healthedgeComExtract.occurrenceCode occurrenceSpanList = new healthedgeComExtract.occurrenceCode();
        String add1 = '';
        String fullZipCode = '';
        String fullPhone = '';
        String attendingPhy = '';
        String operatingPhy = '';
        String payTo = '';
             
        //system.debug('@@hierarchy :'+extractPayload.claimExtract + '@@1 :'+extractPayload.claimExtract.EOBPaymentInformation);
        if(extractPayload.claimExtract <> null && extractPayload.claimExtract.EOBPaymentInformation<>null){
            eList = extractPayload.claimExtract.EOBPaymentInformation;
            system.debug('extractPayload.claimExtract : '+extractPayload.claimExtract);
            system.debug('extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail : '+extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail);
        }
        system.debug('@@eList just after:'+eList);
        if(extractPayload.claimExtract<>null && extractPayload.claimExtract.EOBPaymentInformation[0]<>null
            && extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail<>null && extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0]<>null 
            && extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0].claimLine<>null
            && extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0].claimLine.claimLine<>null){
        
            system.debug('@@test5: '+ extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0].claimLine);
            claimLineList = extractPayload.claimExtract.EOBPaymentInformation[0].eobClaimDetail.claim[0].claimLine.claimLine; 
        }

            system.debug('@@EOBPaymentList : '+ eList.size());
            for(healthEdgeComExtract.claimLine cList : claimLineList){
            system.debug('@@eList inside for:'+eList);
                claim_line_item obj_claim_line_item = new claim_line_item();
                system.debug('healthEdgeComExtract.claimLine :'+ claimLineList);
                system.debug('ClaimLineList size : ' + claimLineList.size()); 
                if(cList.claimLineId<>null){
                    obj_claim_line_item.claim_line_no = cList.claimLineId;//Atul
                }
                
                //Adjustment section
                if(cList.eobBaseBenefitInfo<>null && cList.eobBaseBenefitInfo.claimLineMessages<>null 
                    && cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0]<>null){
                    
                    if(cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageCode<>null){
                        obj_claim_line_item.str_Adjustment_Code = cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageCode;
                    }
                    if(cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageDescription<>null){
                        obj_claim_line_item.str_Adjustment_Code_Desc = cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageDescription;
                    }
                    system.debug('@@adjust codee : '+ obj_claim_line_item.str_Adjustment_Code + '@@ adjust desc :' + obj_claim_line_item.str_Adjustment_Code_Desc);
                }
                 
                if(cList.baseBenefitPlan<>null){
                
                    if(cList.baseBenefitPlan.hccId<>null){
                        obj_claim_line_item.str_Health_Plan_ID  = cList.baseBenefitPlan.hccId; 
                    }
                    if(cList.baseBenefitPlan.name<>null){
                        obj_claim_line_item.str_Plan_Name = cList.baseBenefitPlan.name; 
                    }
                    if(cList.baseBenefitPlan.product<>null){
                        if(cList.baseBenefitPlan.product.planType<>null){
                            obj_claim_line_item.str_Benefit_Plan_Type = cList.baseBenefitPlan.product.planType; 
                        }
                        if(cList.baseBenefitPlan.product.linesOfBusiness<>null && cList.baseBenefitPlan.product.linesOfBusiness.lineOfBusiness[0]<>null){
                            lineofBusiness = cList.baseBenefitPlan.product.linesOfBusiness.lineOfBusiness[0];
                        }
                    }
                }
                if(lineofBusiness.groupName<>null){
                    obj_claim_line_item.str_Group_Name = lineofBusiness.groupName; 
                }                     
                //CPT/HCPCS Info//
                if(cList.serviceCode<>null){
                    obj_claim_line_item.str_Service_Code = cList.serviceCode; 
                }
                if(cList.serviceCodeDesc<>null){
                    obj_claim_line_item.str_Service_Code_Description = cList.serviceCodeDesc; 
                }
                
                if(cList.renderingPractitioner<>null &&cList.renderingPractitioner.practitioner<>null){

                    if(cList.renderingPractitioner.practitioner.namePrefix<>null){
                        operatingPhy = cList.renderingPractitioner.practitioner.namePrefix;
                    }
                    if(cList.renderingPractitioner.practitioner.firstName<>null){
                        operatingPhy = operatingPhy + cList.renderingPractitioner.practitioner.firstName;
                    }
                    if(cList.renderingPractitioner.practitioner.middleName<>null){
                        operatingPhy = operatingPhy + cList.renderingPractitioner.practitioner.middleName;
                    }
                    if(cList.renderingPractitioner.practitioner.lastName<>null){
                        operatingPhy = operatingPhy + cList.renderingPractitioner.practitioner.lastName;
                    }
                    if(cList.renderingPractitioner.practitioner.nameSuffix<>null){
                        operatingPhy = operatingPhy + cList.renderingPractitioner.practitioner.nameSuffix;
                    }
                }
                
                obj_claim_line_item.str_Operating_Physician = operatingPhy;

                obj_claim_line_item.int_claim_no = Integer.valueOf(cList.claimLineId); //listIncrement + 1;
                
                system.debug('@@eList'+eList);
                system.debug('@@eList[0]'+eList[0]);
                //Financial //
                if(eList[0].paymentDate<>null){
                    obj_claim_line_item.str_Payment_Date = eList[0].paymentDate;
                }
                if(eList[0].paymentBatchNumber<>null){
                    obj_claim_line_item.str_Batch_Number = eList[0].paymentBatchNumber;
                }
                if(eList[0].paymentNumber<>null){
                    obj_claim_line_item.str_Check_Number = eList[0].paymentNumber;
                }
                
                //Payer Info
                
                if(eList[0].payerInformation<>null) {
                    if(eList[0].payerInformation.hicName<>null){
                        obj_claim_line_item.str_Payer_Name = eList[0].payerInformation.hicName;
                        obj_claim_line_item.str_Responsible_Party_Name = eList[0].payerInformation.hicName;
                    }
                    
                    //Payer info //
                    if(eList[0].payerInformation.hicAddress<>null) {
                    
                        if(eList[0].payerInformation.hicAddress.address <> null){
                            add1 = eList[0].payerInformation.hicAddress.address;
                        }
                        if(eList[0].payerInformation.hicAddress.address2 <> null){
                            add1 = add1 + ',' + eList[0].payerInformation.hicAddress.address2;
                        }
                        if(eList[0].payerInformation.hicAddress.address3 <> null){
                            add1 = add1 + ',' + eList[0].payerInformation.hicAddress.address3;
                        }
                        obj_claim_line_item.str_Responsible_Party_Address = add1;
                        if(eList[0].payerInformation.hicAddress.city<>null){
                            obj_claim_line_item.str_Responsible_Party_City = eList[0].payerInformation.hicAddress.city;
                        }
                        if(eList[0].payerInformation.hicAddress.stateCode<>null){
                            obj_claim_line_item.str_Responsible_Party_State = eList[0].payerInformation.hicAddress.stateCode;
                        }
                        
                        if(eList[0].payerInformation.hicAddress.zipCode <> null){
                            fullZipCode = eList[0].payerInformation.hicAddress.zipCode;
                        }
                        if(eList[0].payerInformation.hicAddress.zipExtension <> null){
                            fullZipCode = fullZipCode + ',' + eList[0].payerInformation.hicAddress.zipExtension;
                        }
                    }
                    obj_claim_line_item.str_Responsible_Party_Zip = fullZipCode;
                    
                    if(eList[0].payerInformation.hicPhoneNumber<>null){
                        if(eList[0].payerInformation.hicPhoneNumber.areaCode <> null){
                            fullPhone = eList[0].payerInformation.hicPhoneNumber.areaCode;
                        }
                        
                        if(eList[0].payerInformation.hicPhoneNumber.phoneNumber <> null){
                            fullPhone = fullPhone + '-' + eList[0].payerInformation.hicPhoneNumber.phoneNumber;
                        }
                        obj_claim_line_item.str_Responsible_Party_Phone = fullPhone;
                    }
                }
                
                if(eList[0]<>null && eList[0].eobClaimDetail<>null && eList[0].eobClaimDetail.claim[0]<>null){
                    claim = eList[0].eobClaimDetail.claim[0]; 
                }
                system.debug('@@claim :'+claim);
                system.debug('@@claimList : '+ claimList);
                system.debug('@@claimList : '+ claimList.size());
                
                //Header fields
                    if(claim<>null){
                        if(claim.hccId<>null){
                            obj_claim_line_item.claim_id = claim.hccId;
                        }
                        if(claim.type_x<>null){
                            obj_claim_line_item.claim_type = claim.type_x;
                        }
                        if(claim.serviceDateString<>null){
                            obj_claim_line_item.claim_date_service = claim.serviceDateString;
                        }
                        
                        //Header Claim Source //
                        if (claim.clearingHouseTraceNumber != null){
                            obj_claim_line_item.claim_source = 'EDI Claim'; 
                        }
                        else{
                            obj_claim_line_item.claim_source = 'Paper Claim'; 
                        }
                        
                        //Admission/Discharge Info//
                        if(claim.admitDate<>null){
                            obj_claim_line_item.str_Admission_Date = claim.admitDate;
                        }
                        if(claim.admitTime<>null){
                            obj_claim_line_item.str_Admission_Hour = claim.admitTime;
                        }
                        if(claim.admissionTypeCode<>null){
                            obj_claim_line_item.str_Admission_Type = claim.admissionTypeCode;
                        }
                        if(claim.admissionSource<>null){
                            obj_claim_line_item.str_Admission_Source = claim.admissionSource;
                        }
                        if(claim.dischargeTime<>null){
                            obj_claim_line_item.str_Discharge_Hour = claim.dischargeTime; 
                        }
                        
                        //Patient Info//
                        if(claim.patientInformation<>null && claim.patientInformation.member<>null){
                            String name = '';
                            if(claim.patientInformation.member.namePrefix<>null){
                                name = claim.patientInformation.member.namePrefix;
                            }
                            if(claim.patientInformation.member.firstName<>null){
                                name = name + ' ' + claim.patientInformation.member.firstName;
                            }
                            if(claim.patientInformation.member.middleName<>null){
                                name = name + ' ' + claim.patientInformation.member.middleName;
                            }
                            if(claim.patientInformation.member.lastName<>null){
                                name = name + ' ' + claim.patientInformation.member.lastName;
                            }
                            if(claim.patientInformation.member.nameSuffix<>null){
                                name = name + ' '+ claim.patientInformation.member.nameSuffix;
                            }
                            
                            if(name.contains('null')){
                                obj_claim_line_item.str_Patient_Name = name.replaceAll('null','');
                            }else{
                                obj_claim_line_item.str_Patient_Name = name;
                            }
                        }
                        
                        if(claim.patientInformation<>null){
                            String address = '';
                            if(claim.patientInformation.correspondenceAddress<>null){
                                if(claim.patientInformation.correspondenceAddress.address<>null){
                                    address = claim.patientInformation.correspondenceAddress.address;
                                }
                                if(claim.patientInformation.correspondenceAddress.city<>null){
                                    address = address + '\n' + claim.patientInformation.correspondenceAddress.city;
                                }
                                if(claim.patientInformation.correspondenceAddress.stateCode<>null){
                                    address = address + ', ' + claim.patientInformation.correspondenceAddress.stateCode;
                                }
                                if(claim.patientInformation.correspondenceAddress.countryCode<>null){
                                    address = address + ', ' + claim.patientInformation.correspondenceAddress.countryCode;
                                }
                                if(claim.patientInformation.correspondenceAddress.zipCode<>null){
                                    address = address + '\n' + claim.patientInformation.correspondenceAddress.zipCode;
                                }
                                if(claim.patientInformation.correspondenceAddress.zipExtension<>null){
                                    address = address + '-' + claim.patientInformation.correspondenceAddress.zipExtension;
                                }   
                                
                                obj_claim_line_item.str_Patient_Address = address.replaceAll('null','');
                            }
                            
                            if(claim.patientInformation.member<>null){
                                if(claim.patientInformation.member.birthDate<>null){
                                    obj_claim_line_item.str_Patient_Birthday = string.valueof(claim.patientInformation.member.birthDate);
                                }
                                if(claim.patientInformation.member.gender<>null){
                                    obj_claim_line_item.str_Patient_Sex = claim.patientInformation.member.gender;
                                }
                            }
                            if(claim.patientInformation.relationshipToSubscriber<>null){
                                obj_claim_line_item.str_P_Rel_Patients_relationship_to_insured = claim.patientInformation.relationshipToSubscriber;
                            }
                        }
                        
                        //Subscriber Info//
                        if(claim.subscriptionInformation<>null){
                            if(claim.subscriptionInformation.subscriber <>null){
                                if(claim.subscriptionInformation.subscriber.firstName<>null){
                                    obj_claim_line_item.str_Subscriber_First_Name = claim.subscriptionInformation.subscriber.firstName;
                                }
                                if(claim.subscriptionInformation.subscriber.lastName<>null){
                                    obj_claim_line_item.str_Subscriber_Last_Name = claim.subscriptionInformation.subscriber.lastName;
                                }
                            }
                            
                            if(claim.subscriptionInformation.correspondenceAddress<>null){
                                if(claim.subscriptionInformation.correspondenceAddress.city<>null){
                                    obj_claim_line_item.str_Subscriber_City = claim.subscriptionInformation.correspondenceAddress.city;
                                }
                                if(claim.subscriptionInformation.correspondenceAddress.stateCode<>null){
                                    obj_claim_line_item.str_Subscriber_State = claim.subscriptionInformation.correspondenceAddress.stateCode;
                                }
                                if(claim.subscriptionInformation.correspondenceAddress.zipCode<>null){
                                    obj_claim_line_item.str_Subscriber_Zip_Code = claim.subscriptionInformation.correspondenceAddress.zipCode;
                                }
                            }
                            if(claim.subscriptionInformation.hccId<>null){
                                obj_claim_line_item.str_Subscription_ID = claim.subscriptionInformation.hccId;
                            }
                            
                            //Finanacial Info
                            if(claim.clearingHouseTraceNumber<>null){
                                if (claim.clearingHouseTraceNumber == 'Electronic Claim'){
                                    obj_claim_line_item.str_Clearinghouse_Number = claim.clearingHouseTraceNumber; 
                                }
                                else{
                                    obj_claim_line_item.str_Clearinghouse_Number = ''; 
                                }
                            }
                            // Benefit Info Section
                            
                            if(claim.subscriptionInformation.benefitPlan<>null && claim.subscriptionInformation.benefitPlan.accumulators<>null
                                && claim.subscriptionInformation.benefitPlan.accumulators.accumulator<>null 
                                && claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0]<>null){
                                if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription<>null){
                                
                                    if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountUsed<>null){
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Individual Deductible'){
                                            obj_claim_line_item.str_Member_Deductible_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountUsed;
                                        }
                                        else{
                                            obj_claim_line_item.str_Member_Deductible_to_Date = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Family Deductible'){
                                            obj_claim_line_item.str_Family_Deductible_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountUsed;
                                        }
                                        else{
                                            obj_claim_line_item.str_Family_Deductible_to_Date = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Individual Out of Pocket'){
                                            obj_claim_line_item.str_Member_Out_of_Pocket_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountUsed;
                                        }
                                        else{
                                            obj_claim_line_item.str_Member_Out_of_Pocket_to_Date = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Family Out of Pocket'){
                                            obj_claim_line_item.str_Family_Out_of_Pocket_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountUsed;
                                        }
                                        else{
                                            obj_claim_line_item.str_Family_Out_of_Pocket_to_Date = '';
                                        }
                                    }
                                    if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountRemaining<>null){
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Individual Deductible'){
                                            obj_claim_line_item.str_Remaining_Member_Deductible = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountRemaining;
                                        }
                                        else{
                                            obj_claim_line_item.str_Remaining_Member_Deductible = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Family Deductible'){
                                            obj_claim_line_item.str_Remaining_Family_Deductible = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountRemaining;
                                        }
                                        else{
                                            obj_claim_line_item.str_Remaining_Family_Deductible = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Individual Out of Pocket'){
                                            obj_claim_line_item.str_Remaining_Member_Out_of_Pocket_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountRemaining;
                                        }
                                        else{
                                            obj_claim_line_item.str_Remaining_Member_Out_of_Pocket_to_Date = '';
                                        }
                                        if(claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].benefitDescription == 'Family Out of Pocket'){
                                            obj_claim_line_item.str_Remaining_Family_Out_of_Pocket_to_Date = claim.subscriptionInformation.benefitPlan.accumulators.accumulator.accumulator[0].amountRemaining;
                                        }
                                        else{
                                            obj_claim_line_item.str_Remaining_Family_Out_of_Pocket_to_Date = '';
                                        }
                                    }
                                }   
                            }
                        }
                        
                        if(cList.eobBaseBenefitInfo <> null){
                            if(cList.eobBaseBenefitInfo.claimLineMessages <> null){

                                if(cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageDescription <>null){
                                    obj_claim_line_item.str_Denial_Code_Desc = cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageDescription;
                                }
                                if(cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageCode <>null){
                                    obj_claim_line_item.str_Denial_Code = cList.eobBaseBenefitInfo.claimLineMessages.messageMapped[0].messageCode;
                                }
                            }
                        }
                        
                        //Diagnosis/Proc Codes
                        //system.debug('@@procedure Code :'+claim.procedureInfo.principalProcedure); // null 
                        
                        if(claim.procedureInfo<>null && claim.procedureInfo.principalProcedure<>null && claim.procedureInfo.principalProcedure.procedureCode<>null){
                            obj_claim_line_item.str_Procedure_Code = claim.procedureInfo.principalProcedure.procedureCode;
                        }
                        if(claim.procedureInfo<>null && claim.procedureInfo.otherProcedure<>null && claim.procedureInfo.otherProcedure.procedure[0]<>null){ //listincrement?
                        
                            procedure = claim.procedureInfo.otherProcedure.procedure[0]; 
                        }
                        
                        //system.debug('@@otherProcedure :'+claim.procedureInfo); //principalProcedure, otherProcedure null
                        
                        if(procedure<>null && procedure.procedureCode<>null){
                            obj_claim_line_item.str_Other_Procedure_Code = procedure.procedureCode;
                        }
                        if(claim.principalDiagnosis<>null){
                            obj_claim_line_item.str_Diagnosis_Code = claim.principalDiagnosis;
                        }
                        if(claim.prConditionCodes<>null && claim.prConditionCodes.string_x<>null){
                            prConditionCodes_stringList_x = claim.prConditionCodes.string_x;
                        }
                        if(prConditionCodes_stringList_x<>null){
                            obj_claim_line_item.str_Condition_Codes = prConditionCodes_stringList_x;
                        }
                        //system.debug('@@prOccurenceCode :'+claim.prOccurrenceCode); // null
                        
                        if(claim.prOccurrenceCode<>null && claim.prOccurrenceCode.occurrenceCode[0]<>null){
                            occurrenceCodeList = claim.prOccurrenceCode.occurrenceCode[0];
                        }
                        if(claim.prOccurrenceSpan<>null && claim.prOccurrenceSpan.occurrenceCode[0]<>null){
                            occurrenceSpanList = claim.prOccurrenceSpan.occurrenceCode[0];
                        }
                        if(occurrenceCodeList<>null){
                            obj_claim_line_item.str_Occurrence_Code = occurrenceCodeList.occurrenceCode;
                        }
                        if(occurrenceSpanList<>null && occurrenceSpanList.prEndDate<>null && occurrenceSpanList.prStartDate<>null){
                            obj_claim_line_item.str_Occurrence_Span = occurrenceSpanList.prStartDate.daysBetween(occurrenceSpanList.prEndDate);
                        }
                         
                        if(claim.admitDiagnosis<>null){
                            obj_claim_line_item.str_Admit_Diagnosis = claim.admitDiagnosis; // null
                        }
                        
                        system.debug('@@reasonForVisit_string_x :'+claim.reasonForVisitDiagnosis); // null
                        
                        if(claim.reasonForVisitDiagnosis <> null && claim.reasonForVisitDiagnosis.string_x <> null){
                            reasonForVisit_string_x = claim.reasonForVisitDiagnosis.string_x;
                        }                    
                        if(reasonForVisit_string_x <> null){
                            obj_claim_line_item.str_Patient_Reason_Diagnosis = reasonForVisit_string_x;
                        }
                        
                        if(claim.receivedAuthorizationNumber<>null && claim.receivedAuthorizationNumber.string_x<>null){
                            receivedAuth_string_x = claim.receivedAuthorizationNumber.string_x;
                        }
                        if(receivedAuth_string_x <> null){
                            obj_claim_line_item.str_Treatment_Authorization_Codes = receivedAuth_string_x;
                        }
                        
                        //Provider Info//
                        if(claim.typeOfBill<>null){
                            obj_claim_line_item.str_Type_of_Bill = claim.typeOfBill;
                        }
                        
                        if(claim.supplier<>null){
                            if(claim.supplier.name<>null){
                                obj_claim_line_item.str_Provider_Name = claim.supplier.name; 
                            }
                            if(claim.supplier.NPI<>null){
                                obj_claim_line_item.str_Provider_NPI = claim.supplier.NPI; 
                            }
                            if(claim.supplier.TIN<>null){
                                obj_claim_line_item.str_Fed_Tax_Number = claim.supplier.TIN;                             }
                        }
                         
                       if(claim.attendingInformation<>null && claim.attendingInformation.practitioner<>null){
                        
                            if(claim.attendingInformation.practitioner.namePrefix <> null){
                                attendingPhy = claim.attendingInformation.practitioner.namePrefix;
                            }
                            if(claim.attendingInformation.practitioner.firstName <> null){
                                attendingPhy = attendingPhy  + claim.attendingInformation.practitioner.firstName;
                            }
                            if(claim.attendingInformation.practitioner.middleName <> null){
                                attendingPhy = attendingPhy  + claim.attendingInformation.practitioner.middleName;
                            }
                            if(claim.attendingInformation.practitioner.lastName <> null){
                                attendingPhy = attendingPhy  + claim.attendingInformation.practitioner.lastName;
                            }
                            if(claim.attendingInformation.practitioner.nameSuffix <> null){
                                attendingPhy = attendingPhy  + claim.attendingInformation.practitioner.nameSuffix;
                            }
                        }
                        
                        obj_claim_line_item.str_Attending_Physician = attendingPhy; 
                         
                        //Financial Info //
                        
                        if(claim.payToAddress<>null){
                        
                            if(claim.payToAddress.address <> null){
                                payTo = claim.payToAddress.address;
                            }
                            if(claim.payToAddress.address2 <> null){
                                payTo = payTo + ',' + claim.payToAddress.address2;
                            }
                            if(claim.payToAddress.address3 <> null){
                                payTo = payTo + ',' + claim.payToAddress.address3;
                            }
                            if(claim.payToAddress.city <> null){
                                payTo = payTo + ',' + claim.payToAddress.city;
                            }
                            if(claim.payToAddress.stateCode <> null){
                                payTo = payTo + ',' + claim.payToAddress.stateCode;
                            }
                            if(claim.payToAddress.zipCode <> null){
                                payTo = payTo + ',' + claim.payToAddress.zipCode;
                            }
                        }
                        obj_claim_line_item.str_Pay_To = payTo;
                        
                        if(claim.claimTotals<>null){
                        
                            if(claim.claimTotals.memberResponsibilityAmount<>null){
                                obj_claim_line_item.str_Member_Responsibility_Amount = claim.claimTotals.memberResponsibilityAmount;
                            }
                            if(claim.claimTotals.paidAmount<>null){
                                obj_claim_line_item.str_Plan_Paid_Amount = claim.claimTotals.paidAmount;
                            }
                            if(claim.claimTotals.allowedAmount<>null){
                                obj_claim_line_item.str_Total_Allowed_Amount = claim.claimTotals.allowedAmount;
                            }
                            if(claim.claimTotals.inNetworkAllowedAmount<>null){
                                obj_claim_line_item.str_InNetwork_Allowed_Amount = claim.claimTotals.inNetworkAllowedAmount;
                            }
                            if(claim.claimTotals.outNetworkAllowedAmount<>null){
                                obj_claim_line_item.str_Out_Network_Allowed_Amount = claim.claimTotals.outNetworkAllowedAmount;
                            }
                            if(claim.claimTotals.coinsuranceAmount<>null){                  
                                obj_claim_line_item.str_Coinsurance_Amount = claim.claimTotals.coinsuranceAmount;
                            }
                            if(claim.claimTotals.copayAmount<>null){
                                obj_claim_line_item.str_Copay_Amount = claim.claimTotals.copayAmount;
                            }
                            if(claim.claimTotals.deductibleAmount<>null){                   
                                obj_claim_line_item.str_Deductible_Amount = claim.claimTotals.deductibleAmount;
                            }
                            if(claim.claimTotals.nonCoveredCharges<>null){
                                obj_claim_line_item.str_Non_Covered_Charges = claim.claimTotals.nonCoveredCharges;
                            }
                            if(claim.claimTotals.eobPaidAmount<>null){
                                obj_claim_line_item.str_EOB_Paid_Amount = claim.claimTotals.eobPaidAmount;
                            }
                            if(claim.claimTotals.hccAmount<>null){
                                obj_claim_line_item.str_HCC_Amount = claim.claimTotals.hccAmount;
                            }
                            if(claim.claimTotals.hraPaidAmount<>null){                  
                                obj_claim_line_item.str_HRA_Amount = claim.claimTotals.hraPaidAmount;
                            }
                            if(claim.claimTotals.requestedAmount<>null){
                                obj_claim_line_item.str_Requested_Amount = claim.claimTotals.requestedAmount;
                            }
                            if(claim.claimTotals.memberPaidAmount<>null){
                                obj_claim_line_item.str_Member_Paid_Amount = claim.claimTotals.memberPaidAmount;
                            }
                            if(claim.claimTotals.networkSavings<>null){                 
                                obj_claim_line_item.str_Network_Savings = claim.claimTotals.networkSavings;
                            }   
                        }
                        system.debug('@@claim totals :'+claim.claimTotals);
                    }
                        obj_claim_line_item.str_start_service = String.valueOf(cList.serviceStartDate);
                        obj_claim_line_item.str_end_service = String.valueOf(cList.serviceEndDate) ;
                        obj_claim_line_item.cpt_hcpcs_code = cList.serviceCode;
                        //obj_claim_line_item.str_denial_code = '(Emergency......)';
                        obj_claim_line_item.billed = cList.requestedAmount;
                        obj_claim_line_item.hcc_amount = cList.hccAmount; 
                        obj_claim_line_item.line_status = cList.baseStatus;
                        obj_claim_line_item.excluded_reinsurance = false;
                        obj_claim_line_item.excluded_bundling = false;
                        obj_claim_line_item.clean_claim_date = '';
                    
                    system.debug('@@obj_claim_line_item :'+obj_claim_line_item);
                    TotalClaimLineItemList.add(obj_claim_line_item);
                    system.debug('@@TotalClaimLineItemList :'+TotalClaimLineItemList );
                listIncrement++;    

            }
        system.debug('TotalClaimLineItemList before return' + TotalClaimLineItemList.size()); 
        return TotalClaimLineItemList; 
    }
    /**
    *   @Description: This method paginates the total claim line item list based upon page size and increment which are dictated 
    *   by the visual force page/controller displaying the claim detail 
    *   @Arguments: Integer for Increment, Integer for PageSize, Integer for PageNumber
    *   @Return: List of Claim Line Items
    **/
    public List<claim_line_item> paginateClaim( Integer Increment, Integer PageSize, Integer PageNumber){
        List<claim_line_item> paginatedList= new List<claim_line_item>();
        try{
        
        system.debug('increment inside paginateClaim ' + Increment); 
        if(TotalClaimLineItemList.size() <= PageSize){
            paginatedList = TotalClaimLineItemList ; 
        }
        if(TotalClaimLineItemList.size() > PageSize){
            
            if(TotalClaimLineItemList.size() < PageSize * PageNumber){
                for(Integer i = 0; i < PageSize - (PageSize*PageNumber - TotalClaimLineItemList.size()); i++){
                    paginatedList.add(TotalClaimLineItemList[Increment]);
                    Increment++; 
                }
            }
            if(TotalClaimLineItemList.size() > PageSize * PageNumber){
                for(Integer count = 0; count < PageSize; count++){
                    paginatedList.add(TotalClaimLineItemList[Increment]); 
                    Increment++; 
                }
            }
        }
        system.debug('Increment is ' + Increment + ' paginatedlist size ' + paginatedList.size());
        }catch(exception e){}
            return paginatedList; 
    }
    // Constructor that returns the size of the Total list of line items  
    public Integer totalListSize() {
        
        Integer size=0;
        
        if(TotalClaimLineItemList<>null)
            
            size = TotalClaimLineItemList.size();
        
        return size;     
    }
   
}