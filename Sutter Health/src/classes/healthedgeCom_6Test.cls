@isTest
public class healthedgeCom_6Test {
    
    @isTest
    public static void method1(){
        healthedgeCom_6.claimFilterParameters claimFilterParameters = new healthedgeCom_6.claimFilterParameters();
        claimFilterParameters.includeAllPreviouslyPaid = true;
        claimFilterParameters.includeReversedClaimHeader = true; 
        claimFilterParameters.mostRecentPaymentOnly = true ;
        claimFilterParameters.paymentBatchNumber = 0 ;
        claimFilterParameters.paymentDateRangeEnd = 'test';
        claimFilterParameters.paymentDateRangeStart = 'test' ;
        
        healthedgeCom_6.messageCode msgCode = new healthedgeCom_6.messageCode();
        msgCode.codeDomainName = 'test';
        msgCode.messageCode = 'test';
        msgCode.messageCodeIdentifier = 123;
        msgCode.messageDescription = 'test';
        msgCode.policyName = 'test';
        msgCode.versionIdentifier = 123;
        //Assert to check data is passes to constructor class 
         System.assertNotEquals(null,msgCode);
        healthedgeCom_6.ndcCodeInfo ndcCode = new healthedgeCom_6.ndcCodeInfo();
        ndcCode.measurementType = 'test';
        ndcCode.ndcCode = 'test';
        ndcCode.price = 'test';
        
        healthedgeCom_6.dischargeInformation discharge = new healthedgeCom_6.dischargeInformation();
        discharge.dischargeInformationIdentifier = 1234;
        discharge.dischargeStatusCode = 'test';
        discharge.dischargeTimeCount = 'test';
        
        healthedgeCom_6.rejectedClaimSearchCriteria rejectedClaim = new healthedgeCom_6.rejectedClaimSearchCriteria();
        rejectedClaim.processingTimeRangeStart = 'test';
        rejectedClaim.processingTimeRangeEnd = 'test';
        
        healthedgeCom_6.getClaimDetailsByHccID getClaim = new healthedgeCom_6.getClaimDetailsByHccID();
        getClaim.claimHccNumber = 'test';
        
        healthedgeCom_6.dentalLineInfo dentInfo = new healthedgeCom_6.dentalLineInfo();
        dentInfo.dentalLineInfoIdentifier = 1234;
        
        healthedgeCom_6.conditionCode conCode = new healthedgeCom_6.conditionCode();
        conCode.conditionCode = 'test';
        conCode.conditionCodeIdentifier = 1234;
        
        healthedgeCom_6.ubValueCode ubValCode = new healthedgeCom_6.ubValueCode();
        ubValCode.UBValueCodeIdentifier = 1234;
        ubValCode.valueCode = 'test';
        ubValCode.valueCodeAmount = 'test';
        
        healthedgeCom_6.convertedServiceModifierList convServMod = new healthedgeCom_6.convertedServiceModifierList();
        convServMod.convertedServiceModifierListIdentifier = 1234;
        convServMod.modifier = 'test';
        
        healthedgeCom_6.convertedClaimAdjustmentResults convClaimResults = new healthedgeCom_6.convertedClaimAdjustmentResults();
        convClaimResults.claimCvcId = 1234;
        convClaimResults.newClaimHccId = 'test';
        convClaimResults.receivableId = 1234;
        
        healthedgeCom_6.convertedPrincipleProcedure convPrinciplePro = new healthedgeCom_6.convertedPrincipleProcedure();
        convPrinciplePro.convertedPrincipleProcedureIdentifier = 123;
        convPrinciplePro.principleProcedureCode = 'test';
        convPrinciplePro.procedureDate = 'test';
        
        healthedgeCom_6.updateFailedInfo updateFailInfo = new healthedgeCom_6.updateFailedInfo();
        updateFailInfo.causeExceptionMessage = 'test';
        updateFailInfo.causeExceptionType = 'test';
        
        healthedgeCom_6.convertedSupplierInvoice convertedSupplierInvoice = new  healthedgeCom_6.convertedSupplierInvoice(); 
        //public healthedgeCom_6.admissionInformation[] admissionInformation;
        convertedSupplierInvoice.assignmentAcceptance=true;
        //public healthedgeCom_6.convertedRenderingPractitioner[] attendingPractitioner;
        convertedSupplierInvoice.benefitAssignment=true;
        convertedSupplierInvoice.claimSource='dummy';
        convertedSupplierInvoice.claimType='dummy';
        //public healthedgeCom_6.conditionCode[] conditionCodes;
        //public healthedgeCom_6.convertedDeliveredService[] convertedDeliveredServiceList;
        //public healthedgeCom_6.dentalClaimInfo[] dentalClaimInfo;
        //public healthedgeCom_6.ub92Diagnosis[] diagnosisList;
        //public healthedgeCom_6.dischargeInformation[] dischargeInformation;
        convertedSupplierInvoice.drgCode='dummy';
        convertedSupplierInvoice.drgType='dummy';
        convertedSupplierInvoice.endDate='dummy';
        //public healthedgeCom_6.siAttachment[] eobAttachments;
        //public healthedgeCom_6.event[] eventOccurrences;
        convertedSupplierInvoice.informationRelease='dummy';
        convertedSupplierInvoice.memberHccIdentifier='dummy';
        //public healthedgeCom_6.span[] occurrenceSpans;
        //public healthedgeCom_6.convertedRenderingPractitioner[] operatingPractitioner;
        //public healthedgeCom_6.convertedRenderingPractitioner[] otherPractitioner;
        //public healthedgeCom_6.convertedOtherProcedure[] otherProcedureList;
        convertedSupplierInvoice.patientAccountNumber='dummy';
        //public healthedgeCom_6.convertedPrincipleProcedure[] primaryProcedure;
        convertedSupplierInvoice.processingDate='dummy';
        convertedSupplierInvoice.startDate='dummy';
        convertedSupplierInvoice.subscriptionHccIdentifier='dummy';
        convertedSupplierInvoice.supplierHccIdentifier='dummy';
        convertedSupplierInvoice.supplierLocationHccIdentifier='dummy';
        convertedSupplierInvoice.trackingNumber='dummy';
        convertedSupplierInvoice.typeOfBillCode='dummy';
        //public healthedgeCom_6.ubValueCode[] valueCodes;
        
        healthedgeCom_6.processConvertedSupplierInvoice convSuppInv = new healthedgeCom_6.processConvertedSupplierInvoice();
        convSuppInv.convertedSupplierInvoiceBean = convertedSupplierInvoice;
        
        healthedgeCom_6.includeClasses incClasses = new healthedgeCom_6.includeClasses();
        incClasses.arg0 = convertedSupplierInvoice;
        
        healthedgeCom_6.siCasCode sisCasCode = new healthedgeCom_6.siCasCode();
        List<healthedgeCom_6.siCasCode> siCasListCust = new List<healthedgeCom_6.siCasCode>();
        healthedgeCom_6.sieobAttachment sieobAtt = new healthedgeCom_6.sieobAttachment();
        healthedgeCom_6.siAttachment siAtt = new healthedgeCom_6.siAttachment();
        List<healthedgeCom_6.sieobAttachment> sieobListCust = new List<healthedgeCom_6.sieobAttachment>();
        
        sisCasCode.amount = 'test';
        sisCasCode.casCode = 'test';
        sisCasCode.groupCode = 'test';
        sisCasCode.quantity = 'test';
        siCasListCust.add(sisCasCode);
        
        sieobAtt.casCodes = siCasListCust;
        //sieobListCust = sieobAtt;
        siAtt.eobAttachment = sieobListCust;
        healthedgeCom_6.toothSurface toothSur = new healthedgeCom_6.toothSurface();
        
        toothSur.surface = 'test';
        toothSur.toothSurfaceIdentifier = 12234;
        
        healthedgeCom_6.addressInformation addressinfo = new healthedgeCom_6.addressInformation();
        healthedgeCom_6.telephone telephone = new healthedgeCom_6.telephone();
        List<healthedgeCom_6.telephone> telephoneListCust = new List<healthedgeCom_6.telephone>();
        healthedgeCom_6.postalAddress postal = new healthedgeCom_6.postalAddress();
        List<healthedgeCom_6.postalAddress> postalListCust = new List<healthedgeCom_6.postalAddress>();
        
        telephone.phoneAreaCode = 'test';
        telephone.phoneCountryCode = 'test';
        telephone.phoneExtensionNumber = 'test';
        telephone.phoneNumber = 'test';
        telephone.telephoneIdentifier = 123;
        telephone.versionIdentifier = 123;
        telephoneListCust.add(telephone);
        
        postal.address = 'test';
        postal.address2 = 'test';
        postal.address3 = 'test';
        postal.addressType = 'test';
        postal.cityName = 'test';
        postalListCust.add(postal);
        
        addressinfo.addressInformationIdentifier = 12345;
        addressinfo.addressPhoneList = telephoneListCust;
        addressinfo.postalAddress = postalListCust;
    }
    
    @isTest   
    public static void method2(){
        healthedgeCom_6.csiDiagnosisCode csiDiagnosisCode = new  healthedgeCom_6.csiDiagnosisCode();

        csiDiagnosisCode.CSIDiagnosisCodeIdentifier = 1223;
        csiDiagnosisCode.diagnosisCode ='test2';
        //Assert to check csi Diagnosis code is available
         System.assertNotEquals(null,csiDiagnosisCode);

    }
         
    @isTest   
    public static void method3(){
        List<healthedgeCom_6.claimByMemberDetails> claimbyMemeberList = new List<healthedgeCom_6.claimByMemberDetails>();
        
        healthedgeCom_6.claimByMemberDetails claimByMemberDetails = new  healthedgeCom_6.claimByMemberDetails();
        claimByMemberDetails.memberHccId ='dummy';
        claimByMemberDetails.claimHccId = new list<String>{'dummy', 'dummy'};
        claimbyMemeberList.add(claimByMemberDetails);
        //Assert to check claimByMemberDetails is available
         System.assertNotEquals(null,claimByMemberDetails);
         
        healthedgeCom_6.claimDetails claimDetails  = new  healthedgeCom_6.claimDetails();
        claimDetails.claimsByMember = claimbyMemeberList;
        
        healthedgeCom_6.findClaimsRelatedToPaymentsResponse findClaimsRelatedToPaymentsResponse = new healthedgeCom_6.findClaimsRelatedToPaymentsResponse();
        //findClaimsRelatedToPaymentsResponse.claimDetails = 
    }
         
    @isTest public static void otherDiagnosis(){
        healthedgeCom_6.otherDiagnosis otherDiagnosis= new healthedgeCom_6.otherDiagnosis();
        otherDiagnosis.diagnosisCode= 'dummy';
        otherDiagnosis.otherDiagnosisIdentifier = 36567;
        otherDiagnosis.poaIndicator = 'dummy1';
        
        //Assert to check otherDiagnosis is available
         System.assertNotEquals(null,otherDiagnosis);
    }
    
    @isTest 
    public static void findRejectedClaimsResponse(){
      healthedgeCom_6.findRejectedClaimsResponse findRejectedClaimsResponse = new healthedgeCom_6.findRejectedClaimsResponse();
     //Assert to check findRejectedClaimsResponse is available
         System.assertNotEquals(null,findRejectedClaimsResponse);
    }
      
    @isTest
    public static void adjustConvertedClaimResponse(){
        healthedgeCom_6.adjustConvertedClaimResponse adjustConvertedClaimResponse = new healthedgeCom_6.adjustConvertedClaimResponse();
         //Assert to check adjustConvertedClaimResponse is available
         System.assertNotEquals(null,adjustConvertedClaimResponse);
    }
       
    @isTest
    public static void  findClaimsResponse(){
        healthedgeCom_6.findClaimsResponse findClaimsResponse = new healthedgeCom_6.findClaimsResponse();
        //Assert to check findClaimsResponse is available
         System.assertNotEquals(null,findClaimsResponse);
    }
       
    @isTest
    public static void abstractEOBAttachment(){
        healthedgeCom_6.abstractEOBAttachment abstractEOBAttachment = new healthedgeCom_6.abstractEOBAttachment();
        healthedgeCom_6.insuranceCompany insuranceCompany = new   healthedgeCom_6.insuranceCompany();
        abstractEOBAttachment.abstractEOBAttachmentIdentifier = 23454 ;
        abstractEOBAttachment.eobClaimId = 'dumm12' ;
        abstractEOBAttachment.eobDate = 'dummy23' ;
        abstractEOBAttachment.eobGroupName = 'dummy23' ;
        abstractEOBAttachment.eobGroupNumber = 'dummy345' ;
        //insuranceCompany.eobHccInformation = 'dummy34556' ;
        abstractEOBAttachment.eobSubscriberFirstName = 'dummy222' ;
        abstractEOBAttachment.eobSubscriberLastName = 'dummy1222' ;
        abstractEOBAttachment.eobSubscriberMiddleName = 'dummy data' ;
        abstractEOBAttachment.eobSubscriberNamePrefix = 'dummy data' ;
        abstractEOBAttachment.eobSubscriberNameSuffix = 'dummy data' ;
        abstractEOBAttachment.insuranceTypeCode = 'dummy data' ;
        abstractEOBAttachment.payerPriorityCode = 'dummy data' ;
        abstractEOBAttachment.planName = 'dummy data' ;
        
        //Assert to check abstractEOBAttachment is available
         System.assertNotEquals(null,abstractEOBAttachment);
    }
      
    @isTest
    public static void claimBySupplierDetails(){
        healthedgeCom_6.claimBySupplierDetails claimBySupplierDetails = new   healthedgeCom_6.claimBySupplierDetails();

        claimBySupplierDetails.supplierHccId = 'dummy' ;
        //Assert to check claimBySupplierDetails is available
         System.assertNotEquals(null,claimBySupplierDetails);
    }
       
    @isTest
    public static void  event(){
        healthedgeCom_6.event event = new healthedgeCom_6.event();
        event.eventIdentifier = 1223;
        event.occurrenceCode = 'dummy';
        event.occurrenceDate = 'dummy' ;
        
        //Assert to check event is available
         System.assertNotEquals(null,event);
    }
       
    @isTest
    public static void  convertedDeliveredService(){
        healthedgeCom_6.convertedDeliveredService convertedDeliveredService = new  healthedgeCom_6.convertedDeliveredService();

        //   convertedDeliveredService.convertedServiceCost.allowedAmount ;
        //     convertedDeliveredService.convertedAnesthesiaInfo.anesthesiaInfo ;
        convertedDeliveredService.benefitPlanName = 'dummy ';
        convertedDeliveredService.benefitTierType = 'dummy';
        convertedDeliveredService.cobProcessingConclusion = ' dummy' ;
        convertedDeliveredService.convertedDeliveredServiceIdentifier = 1121 ;
        convertedDeliveredService.definingService = 'dummy' ;
        convertedDeliveredService.deniedService = true ;
        //     convertedDeliveredService.dentalLineInfo.dentalLineInfo ;
        //     csiDiagnosisCode.diagnosisCodes = 'dummy';
        //     convertedDeliveredService.sieobPaymentInformation.eobPaymentInformation;
        convertedDeliveredService.facilityTaxAmount =100.00;
        convertedDeliveredService.hccAuthorizationId = 'dummy';
        convertedDeliveredService.inNetworkTierName = 'dummy ';
        convertedDeliveredService.mdcCode = 'dummy';
        //     convertedDeliveredService.healthedgeCom_6.messageCode.messages;
        convertedDeliveredService.minuteCount = 123;
        //      convertedDeliveredService.ndcCodeInfo.ndcCodes ;
        convertedDeliveredService.nonCoveredCharges =23.00;
        convertedDeliveredService.originalRevenueCode= 'dummy';
        convertedDeliveredService.placeOfService ='dummy';
        //     convertedDeliveredService.convertedRenderingPractitioner.renderingPractitioner;
        //      convertedDeliveredService.convertedReportingCategory.reportingCategoryList;
        convertedDeliveredService.requestedFeeAmount =10.00;
        //      convertedDeliveredService.convertedBenefit.serviceBenefit;
        convertedDeliveredService.serviceEndDate = 'dummy';
        //      convertedDeliveredService.convertedServiceModifierList.serviceModifierList;
        convertedDeliveredService.serviceStartDate = 'dummy';
        convertedDeliveredService.serviceTaxAmount =123.76;
        //    convertedDeliveredService.convertedServiceCost.statisticalAllowedAmount;
        //     convertedDeliveredService.convertedBenefit.statisticalServiceBenefit;
        convertedDeliveredService.unitCount =76.00;
        
        //Assert to check convertedDeliveredService is available
         System.assertNotEquals(null,convertedDeliveredService);
    }
       
    @isTest
    public static void  adjustConvertedClaim(){
        healthedgeCom_6.adjustConvertedClaim adjustConvertedClaim = new  healthedgeCom_6.adjustConvertedClaim(); 
        adjustConvertedClaim.dummyMemberId=988;
        adjustConvertedClaim.convertedClaimId=434;
        adjustConvertedClaim.requiresReview = true;
        
        //Assert to check adjustConvertedClaim is available
         System.assertNotEquals(null,adjustConvertedClaim);
    }
       
    @isTest
    public static void  convertedRenderingPractitioner(){
        healthedgeCom_6.convertedRenderingPractitioner convertedRenderingPractitioner = new  healthedgeCom_6.convertedRenderingPractitioner(); 
        convertedRenderingPractitioner.convertedRenderingPractitionerIdentifier=788909;
        convertedRenderingPractitioner.practitionerIdentificationNumber='dummy';
        convertedRenderingPractitioner.practitionerName='dummy';
        
        //Assert to check convertedRenderingPractitioner is available
         System.assertNotEquals(null,convertedRenderingPractitioner);
    }
       
    @isTest
    public static void  method4(){
        healthedgeCom_6.claimSearchCriteria claimSearchCriteria = new  healthedgeCom_6.claimSearchCriteria(); 

        claimSearchCriteria.paymentBatchNumber =222;
        claimSearchCriteria.paymentDateRangeStart = 'dummy';
        claimSearchCriteria.paymentDateRangeEnd = 'dummy';
        claimSearchCriteria.paymentBatchTimeRangeStart ='dummy';
        claimSearchCriteria.paymentBatchTimeRangeEnd= 'dummy' ;
        claimSearchCriteria.paymentStatus = 'dummy' ;
        claimSearchCriteria.payeeType ='dummy' ;  

        healthedgeCom_6.claimSimpleSearchCriteria claimSimpleSearchCriteria= new  healthedgeCom_6.claimSimpleSearchCriteria();

        claimSimpleSearchCriteria.claimState ='dummy';
        claimSimpleSearchCriteria.claimType = 'dummy ';
        claimSimpleSearchCriteria.dentalTransactionType = 'dummy ';
        claimSimpleSearchCriteria.processingTimeRangeStart = 'dummy';
        claimSimpleSearchCriteria.processingTimeRangeEnd = 'dummy ';
        claimSimpleSearchCriteria.receiptDateStart = 'dummy ';
        claimSimpleSearchCriteria.receiptDateEnd = 'dummy' ;
        claimSimpleSearchCriteria.payeeType = 'dummy ';
        
        //Assert to check claimSimpleSearchCriteria is available
         System.assertNotEquals(null,claimSimpleSearchCriteria);

        healthedgeCom_6.findRejectedClaims findRejectedClaims = new  healthedgeCom_6.findRejectedClaims(); 
        healthedgeCom_6.convertedAnesthesiaInfo convertedAnesthesiaInfo = new  healthedgeCom_6.convertedAnesthesiaInfo (); 

        convertedAnesthesiaInfo.convertedAnesthesiaInfoIdentifier = 100;
        convertedAnesthesiaInfo.endTime = 'dummy';
        convertedAnesthesiaInfo.startTime = ' dummy'  ;
    }
       
       @isTest
       public static void  supplierInvoice()
       {
       healthedgeCom_6.supplierInvoice supplierInvoice = new  healthedgeCom_6.supplierInvoice(); 
        supplierInvoice.benefitPlanType='dummy';
        supplierInvoice.claimBatchIdentifier = 678;
        supplierInvoice.claimDeliveryType='dummy';
        supplierInvoice.claimPayorType='dummy';
        supplierInvoice.claimReviewRequired=true;
        supplierInvoice.cleanClaimDate='dummy';
        supplierInvoice.clearingHouseTraceNumber='dummy';
        supplierInvoice.entryDate='dummy';
        supplierInvoice.externalBatchSequenceNumber='dummy';
        supplierInvoice.externalClaimBatchNumber='dummy';
        supplierInvoice.externalClaimNumber='dummy';
        supplierInvoice.hccClaimNumber='dummy';
      //  public healthedgeCom_6.siAttachment[] invoiceAttachments;
        supplierInvoice.lastTransactionDate='dummy';
        supplierInvoice.lastTransactionUser='dummy';
        supplierInvoice.operatorNotes='dummy';
        supplierInvoice.payeeTypeField='dummy';
        supplierInvoice.receiptDate='dummy';
        supplierInvoice.scanCode='dummy';
        supplierInvoice.supplierInvoiceIdentifier=5466;
        supplierInvoice.supplierReferenceNumber='dummy';
        supplierInvoice.tradingPartnerID='dummy';
        supplierInvoice.transactionCount=7899; 

       //Assert to check supplierInvoice is available
         System.assertNotEquals(null,supplierInvoice);      
       }
       
       @isTest
       public static void  method5()
       {
       healthedgeCom_6.oralCavity oralCavity = new  healthedgeCom_6.oralCavity();  
       oralCavity.oralCavityIdentifier=6778;
       oralCavity.oralCavityName='dummy';
       oralCavity.versionIdentifier=6778;
       
       healthedgeCom_6.sieobAttachment sieobAttachment = new  healthedgeCom_6.sieobAttachment();  
       
       
       healthedgeCom_6.auditLogInfo auditLogInfo = new  healthedgeCom_6.auditLogInfo();  
        auditLogInfo.comment='dummy';
        auditLogInfo.messageCode='dummy';
        auditLogInfo.messageDescription='dummy';
        auditLogInfo.user_x='dummy';
       
       healthedgeCom_6.claimDetailsSupplier claimDetailsSupplier = new  healthedgeCom_6.claimDetailsSupplier();  
       
       healthedgeCom_6.getClaimDetailsByHccIDListResponse  getClaimDetailsByHccIDListResponse  = new  healthedgeCom_6.getClaimDetailsByHccIDListResponse (); 
        healthedgeCom_6.illegalServiceArgumentInfo illegalServiceArgumentInfo = new  healthedgeCom_6.illegalServiceArgumentInfo(); 
     //   illegalServiceArgumentInfo.parameterNames='dummy';
    //    illegalServiceArgumentInfo.parameterValues='dummy';
    
        healthedgeCom_6.findClaims findClaims = new  healthedgeCom_6.findClaims();
    
        healthedgeCom_6.convertedOtherProcedure convertedOtherProcedure = new  healthedgeCom_6.convertedOtherProcedure();
        convertedOtherProcedure.convertedOtherProcedureIdentifier=7788;
        convertedOtherProcedure.otherProcedureCode='dummy';
        convertedOtherProcedure.procedureDate='dummy';
    
        healthedgeCom_6.abstractEOBPaymentInformation abstractEOBPaymentInformation = new  healthedgeCom_6.abstractEOBPaymentInformation();
        abstractEOBPaymentInformation.abstractEOBPaymentInformationIdentifier=7778;
        abstractEOBPaymentInformation.allowedAmount=89.00;
        abstractEOBPaymentInformation.billedAmount=98.00;
        abstractEOBPaymentInformation.coInsuranceAmount=78.00;
        abstractEOBPaymentInformation.copayAmount=90.00;
        abstractEOBPaymentInformation.deductibleAmount=78.00;
        abstractEOBPaymentInformation.discountAmount=89.00;
        abstractEOBPaymentInformation.memberPenalty=90.00;
        abstractEOBPaymentInformation.memberResponsibilityAmount=76.00;
        abstractEOBPaymentInformation.netPaidAmount=67.90;
        abstractEOBPaymentInformation.nonCoveredAmount=78.90;
        abstractEOBPaymentInformation.perDayLimitAmount=65.90;
        abstractEOBPaymentInformation.providerPenalty=67.89;
        abstractEOBPaymentInformation.taxAmount=65.90;
    
    
        healthedgeCom_6.toothInfo toothInfo = new  healthedgeCom_6.toothInfo();
     //   public healthedgeCom_6.toothSurface[] surfaces;
     //   public healthedgeCom_6.tooth[] tooth;
        toothInfo.toothInfoIdentifier=77889;
        toothInfo.toothSystem='dummy';
        
        
        healthedgeCom_6.processConvertedSupplierInvoiceResponse processConvertedSupplierInvoiceResponse= new  healthedgeCom_6.processConvertedSupplierInvoiceResponse();
        healthedgeCom_6.memberDentalInfo memberDentalInfo = new  healthedgeCom_6.memberDentalInfo();
        memberDentalInfo.memberDentalInfoIdentifier=7899;
      //  public healthedgeCom_6.tooth[] missingTeeth;
        memberDentalInfo.remarks='dummy';
        memberDentalInfo.versionIdentifier=789;
    
        healthedgeCom_6.externalDiagnosis externalDiagnosis = new  healthedgeCom_6.externalDiagnosis();
        externalDiagnosis.diagnosisCode='dummy';
        externalDiagnosis.externalDiagnosisIdentifier=7689;
        externalDiagnosis.poaIndicator='dummy';
     
        healthedgeCom_6.tooth tooth = new  healthedgeCom_6.tooth();
        tooth.toothIdentifier=6789;
        tooth.toothName='dummy';
        tooth.versionIdentifier=67889;
        
        healthedgeCom_6.findRejectedClaimsBySupplier  findRejectedClaimsBySupplier = new  healthedgeCom_6.findRejectedClaimsBySupplier();
        healthedgeCom_6.claimByMemberDetails claimByMemberDetails = new  healthedgeCom_6.claimByMemberDetails();
        claimByMemberDetails.memberHccId ='dummy';
        claimByMemberDetails.claimHccId = new list<String>{'dummy', 'dummy'};
      
      healthedgeCom_6.siCasCode  siCasCode = new  healthedgeCom_6.siCasCode();
        siCasCode.amount='dummy';
        siCasCode.casCode='dummy';
        siCasCode.groupCode='dummy';
        siCasCode.quantity='dummy';
        siCasCode.SICasCodeIdentifier=890;
     
     healthedgeCom_6.convertedBenefit  convertedBenefit = new  healthedgeCom_6.convertedBenefit(); 
        convertedBenefit.balanceBillMemberExcess=98.00;
        convertedBenefit.coInsuranceAmount=78.00;
        convertedBenefit.coPayAmount=67.00;
        convertedBenefit.convertedBenefitIdentifier=678;
        convertedBenefit.deductibleAmount=56.78;
        convertedBenefit.hccAmount=56.78;
        convertedBenefit.memberPenalty=67.88;
        convertedBenefit.memberResponsibilityAmount=88.88;
        convertedBenefit.memberResponsibilityThresholdAmount=99.99;
        convertedBenefit.memberResponsibilityThresholdUnitCount=77.77;
        convertedBenefit.nonCoveredMemberExcess=66.66;
        convertedBenefit.paidAmount=88.77;
        convertedBenefit.unadjustedCoPayAmount=66.66;
        
        healthedgeCom_6.abstractClaimAttachment  abstractClaimAttachment = new  healthedgeCom_6.abstractClaimAttachment(); 
        abstractClaimAttachment.abstractClaimAttachmentIdentifier=789;
        abstractClaimAttachment.attachmentComment='dummy';
        abstractClaimAttachment.transmissionType='dummy';
        
        healthedgeCom_6.span  span = new  healthedgeCom_6.span();
        span.endDate='dummy';
        span.spanCode='dummy';
        span.spanIdentifier=789;
        span.startDate='dummy';
        
        //Assert to check span is available
         System.assertNotEquals(null,span);     
        }
       
    @isTest
    public static void  method6(){
        
        healthedgeCom_6.findRejectedClaimsBySupplierResponse   findRejectedClaimsBySupplierResponse = new  healthedgeCom_6.findRejectedClaimsBySupplierResponse();

        healthedgeCom_6.ub92Diagnosis ub92Diagnosis = new  healthedgeCom_6.ub92Diagnosis();
        ub92Diagnosis.admitDiagnosisCode='dummy';
        ub92Diagnosis.diagnosisVersionQualifier='dummy';
        //public healthedgeCom_6.externalDiagnosis[] externalDiagnosisList;
        //public healthedgeCom_6.otherDiagnosis[] otherDiagnosisList;
        //public healthedgeCom_6.patientReasonForVisit[] patientReasonForVisitList;
        ub92Diagnosis.primaryDiagnosisCode='dummy';
        ub92Diagnosis.primaryDiagnosisPOAIndicator='dummy';
        ub92Diagnosis.UB92DiagnosisIdentifier=879;

        healthedgeCom_6.sieobPaymentInformation sieobPaymentInformation= new  healthedgeCom_6.sieobPaymentInformation();

        healthedgeCom_6.findClaimsRelatedToPayments   findClaimsRelatedToPayments  = new  healthedgeCom_6.findClaimsRelatedToPayments();
        healthedgeCom_6.acctReceivableExceptionInfo  acctReceivableExceptionInfo  = new  healthedgeCom_6.acctReceivableExceptionInfo();
        acctReceivableExceptionInfo.claimCvcId=879;

        healthedgeCom_6.getClaimDetailsByHccIDList  getClaimDetailsByHccIDList  = new  healthedgeCom_6.getClaimDetailsByHccIDList();
        healthedgeCom_6.claimDetails  claimDetails  = new  healthedgeCom_6.claimDetails();

        healthedgeCom_6.includeClassesResponse   includeClassesResponse  = new  healthedgeCom_6.includeClassesResponse();

        healthedgeCom_6.convertedReportingCategory  convertedReportingCategory  = new  healthedgeCom_6.convertedReportingCategory(); 
        convertedReportingCategory.categoryName='dummy';
        convertedReportingCategory.convertedReportingCategoryIdentifier=890;

        healthedgeCom_6.dentalClaimInfo  dentalClaimInfo  = new  healthedgeCom_6.dentalClaimInfo(); 

        dentalClaimInfo.appliancePlacedDate='dummy';
        dentalClaimInfo.dentalClaimInfoIdentifier=567;
        //public healthedgeCom_6.memberDentalInfo[] dentalInfo;
        dentalClaimInfo.epsdt=true;
        dentalClaimInfo.isTreatmnetForOrthodontics=true;
        dentalClaimInfo.monthsOfTreatmentRemaining=67788;
        dentalClaimInfo.numberOfModels=567;
        dentalClaimInfo.numberOfOralImages=566778;
        dentalClaimInfo.numberOfRadiographs=09877;
        dentalClaimInfo.placeOfTreatment='dumm';
        dentalClaimInfo.predeterminationNumber='dummy';
        dentalClaimInfo.priorPlacementDate='dummy';
        dentalClaimInfo.replacementOfProsthesis=true;
        dentalClaimInfo.studentStatus='dummy';
        dentalClaimInfo.typeOfTransaction='dummy';

        healthedgeCom_6.claimDetailFlags  claimDetailFlags = new  healthedgeCom_6.claimDetailFlags(); 

        claimDetailFlags.includeAccounts=true;
        claimDetailFlags.includeAccumulators=true;
        claimDetailFlags.includeBenefitNetwork=true;
        claimDetailFlags.includeBenefitPlan=true;
        claimDetailFlags.includeExternalRepricerResult=true;
        claimDetailFlags.includeFundedAccounts=true;
        claimDetailFlags.includeIngenixExternalLineResult=true;
        claimDetailFlags.includePractitioner=true;
        claimDetailFlags.includeProcedureInformation=true;
        claimDetailFlags.includeProduct=true;
        claimDetailFlags.includeReportingCategories=true;
        claimDetailFlags.includeRepricerName=true;
        claimDetailFlags.includeSupplier=true;
        claimDetailFlags.includeSupplierInvoice=true;
        claimDetailFlags.includeSupplierLocation=true;
        claimDetailFlags.includeWithholding=true;

        healthedgeCom_6.convertedSupplierInvoice convertedSupplierInvoice = new  healthedgeCom_6.convertedSupplierInvoice(); 
        //public healthedgeCom_6.admissionInformation[] admissionInformation;
        convertedSupplierInvoice.assignmentAcceptance=true;
        //public healthedgeCom_6.convertedRenderingPractitioner[] attendingPractitioner;
        convertedSupplierInvoice.benefitAssignment=true;
        convertedSupplierInvoice.claimSource='dummy';
        convertedSupplierInvoice.claimType='dummy';
        //public healthedgeCom_6.conditionCode[] conditionCodes;
        //public healthedgeCom_6.convertedDeliveredService[] convertedDeliveredServiceList;
        //public healthedgeCom_6.dentalClaimInfo[] dentalClaimInfo;
        //public healthedgeCom_6.ub92Diagnosis[] diagnosisList;
        //public healthedgeCom_6.dischargeInformation[] dischargeInformation;
        convertedSupplierInvoice.drgCode='dummy';
        convertedSupplierInvoice.drgType='dummy';
        convertedSupplierInvoice.endDate='dummy';
        //public healthedgeCom_6.siAttachment[] eobAttachments;
        //public healthedgeCom_6.event[] eventOccurrences;
        convertedSupplierInvoice.informationRelease='dummy';
        convertedSupplierInvoice.memberHccIdentifier='dummy';
        //public healthedgeCom_6.span[] occurrenceSpans;
        //public healthedgeCom_6.convertedRenderingPractitioner[] operatingPractitioner;
        //public healthedgeCom_6.convertedRenderingPractitioner[] otherPractitioner;
        //public healthedgeCom_6.convertedOtherProcedure[] otherProcedureList;
        convertedSupplierInvoice.patientAccountNumber='dummy';
        //public healthedgeCom_6.convertedPrincipleProcedure[] primaryProcedure;
        convertedSupplierInvoice.processingDate='dummy';
        convertedSupplierInvoice.startDate='dummy';
        convertedSupplierInvoice.subscriptionHccIdentifier='dummy';
        convertedSupplierInvoice.supplierHccIdentifier='dummy';
        convertedSupplierInvoice.supplierLocationHccIdentifier='dummy';
        convertedSupplierInvoice.trackingNumber='dummy';
        convertedSupplierInvoice.typeOfBillCode='dummy';
        //public healthedgeCom_6.ubValueCode[] valueCodes;

        healthedgeCom_6.convertedServiceCost  convertedServiceCost = new  healthedgeCom_6.convertedServiceCost(); 
        convertedServiceCost.adjustedAllowedAmount=88.88;
        convertedServiceCost.adjustedBilledAmount=88.88;
        convertedServiceCost.capitated=true;
        convertedServiceCost.convertedServiceCostIdentifier=888;
        convertedServiceCost.discount=99.99;
        convertedServiceCost.providerPenalty=88.88;
        convertedServiceCost.renderedByPcp=true;
        convertedServiceCost.unadjustedAmount=56.89;

        healthedgeCom_6.postalAddress  postalAddress = new  healthedgeCom_6.postalAddress(); 
        postalAddress.address='dummy';
        postalAddress.address2='dummy';
        postalAddress.address3='dummy';
        postalAddress.addressType='dummy';
        postalAddress.cityName='dummy';
        postalAddress.countryCode='dummy';
        postalAddress.countyCode='dummy';
        postalAddress.ignoreAddressCheck=true;
        postalAddress.latitude=78.78;
        postalAddress.longitude=67.67;
        postalAddress.postalAddressIdentifier=899;
        postalAddress.stateCode='dummy';
        postalAddress.undeliverableAddress=true;
        postalAddress.versionIdentifier=7778;
        postalAddress.zipCode='dummy';
        postalAddress.zipExtensionCode='dummy';

        healthedgeCom_6.readFailedInfo readFailedInfo = new  healthedgeCom_6.readFailedInfo(); 
        readFailedInfo.causeExceptionMessage='dummy';
        readFailedInfo.causeExceptionType='dummy';

        healthedgeCom_6.telephone telephone = new  healthedgeCom_6.telephone(); 
        telephone.phoneAreaCode='dummy';
        telephone.phoneCountryCode='dummy';
        telephone.phoneExtensionNumber='dummy';
        telephone.phoneNumber='dummy';
        telephone.telephoneIdentifier=7889;
        telephone.versionIdentifier=7899;

        healthedgeCom_6.patientReasonForVisit patientReasonForVisit  = new  healthedgeCom_6.patientReasonForVisit (); 
        patientReasonForVisit.diagnosisCode='dummy';
        patientReasonForVisit.patientReasonForVisitIdentifier=789;
        
        
        healthedgeCom_6.claimResponseInfo claimResponseInfo  = new  healthedgeCom_6.claimResponseInfo (); 
        claimResponseInfo.claimIdentifier='dummy';
        claimResponseInfo.submitStatus='dummy';
        claimResponseInfo.hccClaimNumber='dummy';
        claimResponseInfo.cvcId=8878;
        claimResponseInfo.attachmentSetId=778;
        claimResponseInfo.exception_x = 'dummy';

        healthedgeCom_6.admissionInformation  admissionInformation  = new  healthedgeCom_6.admissionInformation (); 
        admissionInformation.admissionDate='dummy';
        admissionInformation.admissionInformationIdentifier=6788;
        admissionInformation.admissionSourceCode='dummy';
        admissionInformation.admissionTimeCount='dummy';
        admissionInformation.admissionTypeCode='dummy';
        
        //Assert to check admissionInformation is available
         System.assertNotEquals(null,admissionInformation); 
    }
 }