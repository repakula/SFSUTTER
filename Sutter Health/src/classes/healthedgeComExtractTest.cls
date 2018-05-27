@isTest
public class healthedgeComExtractTest{

    @isTest
    public static void toothInfo(){
    
        healthedgeComExtract.toothInfo toothinfo = new healthedgeComExtract.toothInfo();
        List<healthedgeComExtract.toothInfo> toothinfoList = new List<healthedgeComExtract.toothInfo>();
        
        toothinfo.toothSystem = 'toothsystem';
        toothinfo.tooth = 'tooth';
        toothinfoList.add(toothinfo);
        //Assert to check toothinfo is available 
         System.assertNotEquals(null,toothinfo);
    }   
    
    @isTest
    public static healthedgeComExtract.ingenixFlagList flagList(){
    
        healthedgeComExtract.ingenixFlagList ingFlagList = new healthedgeComExtract.ingenixFlagList();
        healthedgeComExtract.ingenixFlag ingFlag = new healthedgeComExtract.ingenixFlag();
        List<healthedgeComExtract.ingenixFlag> ingFlagListCust = new List<healthedgeComExtract.ingenixFlag>();
        
        ingFlag.action = 'test';
        ingFlag.errorLevel = 'test';
        ingFlag.message = 'test';
        ingFlag.mnemonic = 'test';
        ingFlag.percent = 'test';
        ingFlagListCust.add(ingFlag);
        
        //Assert to check ingFlag is available 
         System.assertNotEquals(null,ingFlag);
        
        ingFlagList.ingenixFlag = ingFlagListCust;
        return ingFlagList;
    }
    
  @isTest
  public static void subscriptionInformation()
  {
    healthedgeComExtract.subscriptionInformation subscriptionInformation= new healthedgeComExtract.subscriptionInformation();
   // healthedgeComExtract.subscriptionInformation.account account = new healthedgeComExtract.subscriptionInformation.account();
        subscriptionInformation.coverageTier='dummy';
        subscriptionInformation.groupName='dummy';
        subscriptionInformation.groupNumber='dummy';
        subscriptionInformation.hccId='dummy';
        subscriptionInformation.otherGroupName='dummy';
        subscriptionInformation.otherGroupNumber='dummy';
        
        //Assert to check subscriptionInformation is available 
         System.assertNotEquals(null,subscriptionInformation);
     //   account.account='dummy';
    //    subscriptionInformation.benefitPlan;
    //    subscriptionInformation.correspondenceAddress;
   //     subscriptionInformation.correspondenceName;
   //     subscriptionInformation.subscriber;
    //    subscriptionInformation.topAccount;
  }
  
   @isTest
  public static void Method1()
  {
   healthedgeComExtract.repricerInformation repricerInformation= new healthedgeComExtract.repricerInformation();
        repricerInformation.allowedAmount='dummy';
        repricerInformation.benefitNetworkName='dummy';
        repricerInformation.repricerName='dummy';
       repricerInformation.requestDate = System.today();
    //    public healthedgeComExtract.messageList messages;
    
        healthedgeComExtract.lineOfBusiness  lineOfBusiness = new healthedgeComExtract.lineOfBusiness();
        lineOfBusiness.groupName='dummy';
        lineOfBusiness.lineOfBusinessName='dummy';
    
    //    public healthedgeComExtract.address correspondenceAddress;
     //   public healthedgeComExtract.stringList otherIdentificationNumber;
     //   public healthedgeComExtract.specialtyInformationList speciality;
        
        
        healthedgeComExtract.phoneNumber   phoneNumber  = new healthedgeComExtract.phoneNumber();
        phoneNumber.areaCode='dummy';
        phoneNumber.extension='dummy';
        phoneNumber.phoneNumber='dummy';
        phoneNumber.phoneType='dummy';
        phoneNumber.phoneTypeCode='dummy';
        
        //Assert to check phoneNumber is available 
         System.assertNotEquals(null,phoneNumber);
        
        healthedgeComExtract.specialtyInformationList    specialtyInformationList   = new healthedgeComExtract.specialtyInformationList();
        
        healthedgeComExtract.reportingCategoryList    reportingCategoryList  = new healthedgeComExtract.reportingCategoryList();
        healthedgeComExtract.lineOfBusinessList     lineOfBusinessList  = new healthedgeComExtract.lineOfBusinessList ();
        healthedgeComExtract.identificationNumberList    identificationNumberList   = new healthedgeComExtract.identificationNumberList ();
       }
    
    @isTest
    public static healthEdgeComExtract.extractPayload claim1() {
    
        healthedgeComExtract.claimLineList claimLineOne = new healthedgeComExtract.claimLineList();
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        
        healthEdgeComExtract.extractPayload extpayload = new healthEdgeComExtract.extractPayload();
        healthedgeComExtract.instanceList instList = new healthedgeComExtract.instanceList();
        List<healthedgeComExtract.EOBPaymentInformation> eobpaymentList = new List<healthedgeComExtract.EOBPaymentInformation>();    
        healthedgeComExtract.EOBPaymentInformation eobpayment = new healthedgeComExtract.EOBPaymentInformation();
        healthedgeComExtract.claimList claimList = new healthedgeComExtract.claimList();
        
        List<healthedgeComExtract.claim> claims = new List<healthedgeComExtract.claim>();
        healthedgeComExtract.claim claim = new healthedgeComExtract.claim();
        
        //Assert to check claim is available 
         System.assertNotEquals(null,claim);
        
        healthedgeComExtract.payer payer = new healthedgeComExtract.payer();
        healthedgeComExtract.address add = new healthedgeComExtract.address();
        healthedgeComExtract.phoneNumber hicPhone = new healthedgeComExtract.phoneNumber();
        
        healthedgeComExtract.patientInformation patInfo = new healthedgeComExtract.patientInformation();
        
        healthedgeComExtract.individual ind = new healthedgeComExtract.individual();
        
        healthedgeComExtract.subscriptionInformation subscription = new healthedgeComExtract.subscriptionInformation();
        
        healthedgeComExtract.stringList strList = new healthedgeComExtract.stringList();
        
        healthedgeComExtract.practitioner rendPract = new healthedgeComExtract.practitioner();
        
        healthedgeComExtract.supplierClaimInformation supplierClaimInformation = new healthedgeComExtract.supplierClaimInformation();
        
        healthedgeComExtract.claimTotals totals = new healthedgeComExtract.claimTotals();
        
        healthedgeComExtract.benefitPlanInformation benefitPlanInformation = new healthedgeComExtract.benefitPlanInformation();
        
        healthedgeComExtract.accumulatorsInformation accumulatorInfo = new healthedgeComExtract.accumulatorsInformation();
        
        healthedgeComExtract.accumulatorList accumList = new healthedgeComExtract.accumulatorList();
        
        healthedgeComExtract.accumulator accum = new healthedgeComExtract.accumulator();
        List<healthedgeComExtract.accumulator> accumListCust = new List<healthedgeComExtract.accumulator>();
        
        accum.amountDefined = '1234';
        accum.amountRemaining = '1234';
        accum.amountUsed = '1234';
        accum.benefitDescription = 'Family Deductible';
        accumListCust.add(accum);
        
        accumList.accumulator = accumListCust;
        
        accumulatorInfo.accumulator = accumList;
        
        benefitPlanInformation.endDate = System.today();
        benefitPlanInformation.firstRenewalDate = System.today();
        benefitPlanInformation.hccId = 'dummy';
        benefitPlanInformation.name = 'dummy';
        benefitPlanInformation.planStartDay = 77898;
        benefitPlanInformation.planStartMonth = 'dummy';
        benefitPlanInformation.renewalInterval = 5678;
        benefitPlanInformation.startDate = System.today();
        
        benefitPlanInformation.accumulators = accumulatorInfo;
        
        subscription.benefitPlan = benefitPlanInformation;
        
        supplierClaimInformation.NPI='dummy';
        supplierClaimInformation.TIN='dummy';
        supplierClaimInformation.activeSinceDate=System.today();
        supplierClaimInformation.firstActiveDate=System.today();
        supplierClaimInformation.hccId ='dummy';
        supplierClaimInformation.name='dummy';
        
        ind.nameSuffix = 'suffix';
        ind.namePrefix = 'suffix';
        ind.firstName = 'dummy';
        ind.middleName = 'dummy';
        ind.lastName = 'dummy';
        ind.birthDate = date.today();
        ind.gender = 'male';
        
        add.address = 'dummy';
        add.address2 = 'dummy';
        add.address3 = 'dummy';
        add.city = 'dummy';
        add.stateCode = 'dummy';
        add.zipCode = 'dummy';
        add.zipExtension = 'dummy';
        add.countryCode = 'dummy';
        hicPhone.phoneNumber = '123456';
        
        payer.hicAddress = add;
        payer.hicPhoneNumber = hicPhone;
        patInfo.member = ind;
        patInfo.correspondenceAddress = add;
        patInfo.relationshipToSubscriber = 'dummy';
        eobpayment.payerInformation = payer;
        
        subscription.subscriber = ind;
        subscription.correspondenceAddress = add;
        subscription.hccId = '12345';
        
        claim.clearingHouseTraceNumber = '1234567';
        
        claim.subscriptionInformation = subscription;
        
        strList.string_x = new List<String>{'A', 'B'};
        
        rendPract.practitioner = ind;
        totals.memberResponsibilityAmount = 'dummy';
        totals.networkSavings = '123';
        totals.memberPaidAmount = '123';
        totals.requestedAmount = '123';
        totals.hraPaidAmount = '123';
        totals.hccAmount = '123';
        totals.eobPaidAmount = '123';
        totals.eobPaidAmount = '123';
        totals.deductibleAmount = '123';
        totals.copayAmount = '123';
        totals.coinsuranceAmount = '123';
        totals.outNetworkAllowedAmount = '123';
        totals.inNetworkAllowedAmount = '123';
        totals.allowedAmount = '123';
        totals.paidAmount = '123';
        
        claim.attendingInformation = rendPract;
        claim.supplier = supplierClaimInformation;
        claim.reasonForVisitDiagnosis = strList;
        claim.receivedAuthorizationNumber = strList;
        claim.patientInformation = patInfo;
        claim.payToAddress = add;
        claim.claimTotals = totals;
        claim.admissionSource='dummy';
        claim.admissionTypeCode='dummy';
        claim.admitDate = date.today();
        claim.admitDiagnosis='dummy';
        claim.admitTime='dummy';
        claim.allowedAmount='dummy';
        claim.assignmentAcceptance='dummy';
        claim.benefitAssignment='dummy';
        claim.calculatedDRGCode='dummy';
        claim.claimIdentifier=7890;
        claim.clearingHouseTraceNumber = 'dummy';
        claim.dischargeStatus='dummy';
        claim.dischargeTime='dummy';
        claim.endDate=System.today();
        claim.entryDate=System.today();
        claim.externalClaimBatchNumber='dummy';
        claim.externalClaimId='dummy';
        claim.hccAmount='dummy';
        claim.hccId='dummy';
        claim.hospitalizationEndDate=System.today();
        claim.hospitalizationStartDate=System.today();
        claim.inNetwork='dummy';
        claim.informationRelease='dummy';
        claim.interestAmount='dummy';
        claim.medicalRecordNumber='dummy';
        claim.memberAmount='dummy';
        claim.memberPaidAmount='dummy';
        claim.operator='dummy';
        claim.originalSubscriberId='dummy';
        claim.otherHealthBenefitPlanExist=true;
        claim.patientAccountNumber='dummy';
        claim.patientControlNumber='dummy';
        claim.principalDiagnosis='dummy';
        claim.processingDate=System.today();
        claim.providerPenalty='dummy';
        claim.providerSignaturePresent='dummy';
        claim.receiptDate=System.today();
        claim.requestedFeeAmount='dummy';
        claim.reverseEntry=true;
        claim.serviceDateString='dummy';
        claim.startDate=System.today();
        claim.state='dummy';
        claim.submittedDRGCode='dummy';
        claim.supplierInvoiceNumber='dummy';
        claim.supplierReferenceNumber='dummy';
        claim.type_x='dummy';
        claim.typeOfBill='dummy';
        claim.typeOfBillCode='dummy';
        claim.withholdAmount='dummy';
        claimLineOne.claimLine = healthedgeComExtractTest.claimLineList();
        system.debug('@@claimLineList[] claim :'+claimLineOne.claimLine);
        claim.claimLine = claimLineOne;
        system.debug('@@claim.claimLine :'+claim.claimLine);
        claims.add(claim);
        
        claimList.claim = claims;
        
        eobpayment.eobClaimDetail = claimList;
        datetime myDateTime = datetime.now();
        eobpayment.paymentTime = myDateTime;
        eobpayment.paymentStatusDate = date.today();
        eobpayment.paymentNumber = 3;
        eobpayment.paymentDate = date.today();
        eobpayment.paymentBatchNumber = 6;
        system.debug('@@eobpayment :'+eobpayment);
        eobpaymentList.add(eobpayment);
        system.debug('@@eobpaymentList :'+eobpaymentList);
        
        instList.EOBPaymentInformation = eobpaymentList;
        system.debug('@@instList :'+instList);
        
        extpayload.claimExtract = instList;
        system.debug('@@extpayload.claimExtract :'+extpayload);
        
        system.debug('@@extpayload :'+extpayload);
        
        return extpayload;
    }
    
    @isTest
    public static healthEdgeComExtract.extractPayload claim2() {
    
        healthedgeComExtract.claimLineList claimLineOne = new healthedgeComExtract.claimLineList();
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        
        healthEdgeComExtract.extractPayload extpayload = new healthEdgeComExtract.extractPayload();
        healthedgeComExtract.instanceList instList = new healthedgeComExtract.instanceList();
        List<healthedgeComExtract.EOBPaymentInformation> eobpaymentList = new List<healthedgeComExtract.EOBPaymentInformation>();    
        healthedgeComExtract.EOBPaymentInformation eobpayment = new healthedgeComExtract.EOBPaymentInformation();
        healthedgeComExtract.claimList claimList = new healthedgeComExtract.claimList();
        
        List<healthedgeComExtract.claim> claims = new List<healthedgeComExtract.claim>();
        healthedgeComExtract.claim claim = new healthedgeComExtract.claim();
        
        
        
        healthedgeComExtract.payer payer = new healthedgeComExtract.payer();
        healthedgeComExtract.address add = new healthedgeComExtract.address();
        healthedgeComExtract.phoneNumber hicPhone = new healthedgeComExtract.phoneNumber();
        
        healthedgeComExtract.patientInformation patInfo = new healthedgeComExtract.patientInformation();
        
        healthedgeComExtract.individual ind = new healthedgeComExtract.individual();
        
        healthedgeComExtract.subscriptionInformation subscription = new healthedgeComExtract.subscriptionInformation();
        
        healthedgeComExtract.stringList strList = new healthedgeComExtract.stringList();
        
        healthedgeComExtract.practitioner rendPract = new healthedgeComExtract.practitioner();
        
        healthedgeComExtract.supplierClaimInformation supplierClaimInformation = new healthedgeComExtract.supplierClaimInformation();
        
        healthedgeComExtract.claimTotals totals = new healthedgeComExtract.claimTotals();
        
        healthedgeComExtract.benefitPlanInformation benefitPlanInformation = new healthedgeComExtract.benefitPlanInformation();
        
        healthedgeComExtract.accumulatorsInformation accumulatorInfo = new healthedgeComExtract.accumulatorsInformation();
        
        healthedgeComExtract.accumulatorList accumList = new healthedgeComExtract.accumulatorList();
        
        healthedgeComExtract.accumulator accum = new healthedgeComExtract.accumulator();
        List<healthedgeComExtract.accumulator> accumListCust = new List<healthedgeComExtract.accumulator>();
        
        accum.amountDefined = '1234';
        accum.amountRemaining = '1234';
        accum.amountUsed = '1234';
        accum.benefitDescription = 'Individual Deductible';
        accumListCust.add(accum);
        //Assert to check accumulator is available 
         System.assertNotEquals(null,accumList);
        
        accumList.accumulator = accumListCust;
        
        accumulatorInfo.accumulator = accumList;
        
        benefitPlanInformation.endDate = System.today();
        benefitPlanInformation.firstRenewalDate = System.today();
        benefitPlanInformation.hccId = 'dummy';
        benefitPlanInformation.name = 'dummy';
        benefitPlanInformation.planStartDay = 77898;
        benefitPlanInformation.planStartMonth = 'dummy';
        benefitPlanInformation.renewalInterval = 5678;
        benefitPlanInformation.startDate = System.today();
        
        benefitPlanInformation.accumulators = accumulatorInfo;
        
        subscription.benefitPlan = benefitPlanInformation;
        
        supplierClaimInformation.NPI='dummy';
        supplierClaimInformation.TIN='dummy';
        supplierClaimInformation.activeSinceDate=System.today();
        supplierClaimInformation.firstActiveDate=System.today();
        supplierClaimInformation.hccId ='dummy';
        supplierClaimInformation.name='dummy';
        
        ind.nameSuffix = 'suffix';
        ind.namePrefix = 'suffix';
        ind.firstName = 'dummy';
        ind.middleName = 'dummy';
        ind.lastName = 'dummy';
        ind.birthDate = date.today();
        ind.gender = 'male';
        
        add.address = 'dummy';
        add.address2 = 'dummy';
        add.address3 = 'dummy';
        add.city = 'dummy';
        add.stateCode = 'dummy';
        add.zipCode = 'dummy';
        add.zipExtension = 'dummy';
        add.countryCode = 'dummy';
        hicPhone.phoneNumber = '123456';
        
        payer.hicAddress = add;
        payer.hicPhoneNumber = hicPhone;
        patInfo.member = ind;
        patInfo.correspondenceAddress = add;
        patInfo.relationshipToSubscriber = 'dummy';
        eobpayment.payerInformation = payer;
        
        subscription.subscriber = ind;
        subscription.correspondenceAddress = add;
        subscription.hccId = '12345';
        
        claim.clearingHouseTraceNumber = '1234567';
        
        claim.subscriptionInformation = subscription;
        
        strList.string_x = new List<String>{'A', 'B'};
        
        rendPract.practitioner = ind;
        totals.memberResponsibilityAmount = 'dummy';
        totals.networkSavings = '123';
        totals.memberPaidAmount = '123';
        totals.requestedAmount = '123';
        totals.hraPaidAmount = '123';
        totals.hccAmount = '123';
        totals.eobPaidAmount = '123';
        totals.eobPaidAmount = '123';
        totals.deductibleAmount = '123';
        totals.copayAmount = '123';
        totals.coinsuranceAmount = '123';
        totals.outNetworkAllowedAmount = '123';
        totals.inNetworkAllowedAmount = '123';
        totals.allowedAmount = '123';
        totals.paidAmount = '123';
        
        claim.attendingInformation = rendPract;
        claim.supplier = supplierClaimInformation;
        claim.reasonForVisitDiagnosis = strList;
        claim.receivedAuthorizationNumber = strList;
        claim.patientInformation = patInfo;
        claim.payToAddress = add;
        claim.claimTotals = totals;
        claim.admissionSource='dummy';
        claim.admissionTypeCode='dummy';
        claim.admitDate = date.today();
        claim.admitDiagnosis='dummy';
        claim.admitTime='dummy';
        claim.allowedAmount='dummy';
        claim.assignmentAcceptance='dummy';
        claim.benefitAssignment='dummy';
        claim.calculatedDRGCode='dummy';
        claim.claimIdentifier=7890;
        claim.clearingHouseTraceNumber = 'dummy';
        claim.dischargeStatus='dummy';
        claim.dischargeTime='dummy';
        claim.endDate=System.today();
        claim.entryDate=System.today();
        claim.externalClaimBatchNumber='dummy';
        claim.externalClaimId='dummy';
        claim.hccAmount='dummy';
        claim.hccId='dummy';
        claim.hospitalizationEndDate=System.today();
        claim.hospitalizationStartDate=System.today();
        claim.inNetwork='dummy';
        claim.informationRelease='dummy';
        claim.interestAmount='dummy';
        claim.medicalRecordNumber='dummy';
        claim.memberAmount='dummy';
        claim.memberPaidAmount='dummy';
        claim.operator='dummy';
        claim.originalSubscriberId='dummy';
        claim.otherHealthBenefitPlanExist=true;
        claim.patientAccountNumber='dummy';
        claim.patientControlNumber='dummy';
        claim.principalDiagnosis='dummy';
        claim.processingDate=System.today();
        claim.providerPenalty='dummy';
        claim.providerSignaturePresent='dummy';
        claim.receiptDate=System.today();
        claim.requestedFeeAmount='dummy';
        claim.reverseEntry=true;
        claim.serviceDateString='dummy';
        claim.startDate=System.today();
        claim.state='dummy';
        claim.submittedDRGCode='dummy';
        claim.supplierInvoiceNumber='dummy';
        claim.supplierReferenceNumber='dummy';
        claim.type_x='dummy';
        claim.typeOfBill='dummy';
        claim.typeOfBillCode='dummy';
        claim.withholdAmount='dummy';
        claimLineOne.claimLine = healthedgeComExtractTest.claimLineList();
        system.debug('@@claimLineList[] claim :'+claimLineOne.claimLine);
        claim.claimLine = claimLineOne;
        system.debug('@@claim.claimLine :'+claim.claimLine);
        claims.add(claim);
        
        claimList.claim = claims;
        
        eobpayment.eobClaimDetail = claimList;
        datetime myDateTime = datetime.now();
        eobpayment.paymentTime = myDateTime;
        eobpayment.paymentStatusDate = date.today();
        eobpayment.paymentNumber = 3;
        eobpayment.paymentDate = date.today();
        eobpayment.paymentBatchNumber = 6;
        system.debug('@@eobpayment :'+eobpayment);
        eobpaymentList.add(eobpayment);
        system.debug('@@eobpaymentList :'+eobpaymentList);
        
        instList.EOBPaymentInformation = eobpaymentList;
        system.debug('@@instList :'+instList);
        
        extpayload.claimExtract = instList;
        system.debug('@@extpayload.claimExtract :'+extpayload);
        
        system.debug('@@extpayload :'+extpayload);
        
        return extpayload;
    }
    
    @isTest
    public static healthEdgeComExtract.extractPayload claim3() {
    
        healthedgeComExtract.claimLineList claimLineOne = new healthedgeComExtract.claimLineList();
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        
        healthEdgeComExtract.extractPayload extpayload = new healthEdgeComExtract.extractPayload();
        healthedgeComExtract.instanceList instList = new healthedgeComExtract.instanceList();
        List<healthedgeComExtract.EOBPaymentInformation> eobpaymentList = new List<healthedgeComExtract.EOBPaymentInformation>();    
        healthedgeComExtract.EOBPaymentInformation eobpayment = new healthedgeComExtract.EOBPaymentInformation();
        healthedgeComExtract.claimList claimList = new healthedgeComExtract.claimList();
        
        List<healthedgeComExtract.claim> claims = new List<healthedgeComExtract.claim>();
        healthedgeComExtract.claim claim = new healthedgeComExtract.claim();
        
        healthedgeComExtract.payer payer = new healthedgeComExtract.payer();
        healthedgeComExtract.address add = new healthedgeComExtract.address();
        healthedgeComExtract.phoneNumber hicPhone = new healthedgeComExtract.phoneNumber();
        
        healthedgeComExtract.patientInformation patInfo = new healthedgeComExtract.patientInformation();
        
        healthedgeComExtract.individual ind = new healthedgeComExtract.individual();
        
        healthedgeComExtract.subscriptionInformation subscription = new healthedgeComExtract.subscriptionInformation();
        
        healthedgeComExtract.stringList strList = new healthedgeComExtract.stringList();
        
        healthedgeComExtract.practitioner rendPract = new healthedgeComExtract.practitioner();
        
        healthedgeComExtract.supplierClaimInformation supplierClaimInformation = new healthedgeComExtract.supplierClaimInformation();
        
        healthedgeComExtract.claimTotals totals = new healthedgeComExtract.claimTotals();
        
        healthedgeComExtract.benefitPlanInformation benefitPlanInformation = new healthedgeComExtract.benefitPlanInformation();
        
        healthedgeComExtract.accumulatorsInformation accumulatorInfo = new healthedgeComExtract.accumulatorsInformation();
        
        healthedgeComExtract.accumulatorList accumList = new healthedgeComExtract.accumulatorList();
        
        healthedgeComExtract.accumulator accum = new healthedgeComExtract.accumulator();
        List<healthedgeComExtract.accumulator> accumListCust = new List<healthedgeComExtract.accumulator>();
        
        accum.amountDefined = '1234';
        accum.amountRemaining = '1234';
        accum.amountUsed = '1234';
        accum.benefitDescription = 'Individual Out of Pocket';
        accumListCust.add(accum);
        //Assert to check accumulator is available 
         System.assertNotEquals(null,accum);
        
        accumList.accumulator = accumListCust;
        
        accumulatorInfo.accumulator = accumList;
        
        benefitPlanInformation.endDate = System.today();
        benefitPlanInformation.firstRenewalDate = System.today();
        benefitPlanInformation.hccId = 'dummy';
        benefitPlanInformation.name = 'dummy';
        benefitPlanInformation.planStartDay = 77898;
        benefitPlanInformation.planStartMonth = 'dummy';
        benefitPlanInformation.renewalInterval = 5678;
        benefitPlanInformation.startDate = System.today();
        
        benefitPlanInformation.accumulators = accumulatorInfo;
        
        subscription.benefitPlan = benefitPlanInformation;
        
        supplierClaimInformation.NPI='dummy';
        supplierClaimInformation.TIN='dummy';
        supplierClaimInformation.activeSinceDate=System.today();
        supplierClaimInformation.firstActiveDate=System.today();
        supplierClaimInformation.hccId ='dummy';
        supplierClaimInformation.name='dummy';
        
        ind.nameSuffix = 'suffix';
        ind.namePrefix = 'suffix';
        ind.firstName = 'dummy';
        ind.middleName = 'dummy';
        ind.lastName = 'dummy';
        ind.birthDate = date.today();
        ind.gender = 'male';
        
        add.address = 'dummy';
        add.address2 = 'dummy';
        add.address3 = 'dummy';
        add.city = 'dummy';
        add.stateCode = 'dummy';
        add.zipCode = 'dummy';
        add.zipExtension = 'dummy';
        add.countryCode = 'dummy';
        hicPhone.phoneNumber = '123456';
        
        payer.hicAddress = add;
        payer.hicPhoneNumber = hicPhone;
        patInfo.member = ind;
        patInfo.correspondenceAddress = add;
        patInfo.relationshipToSubscriber = 'dummy';
        eobpayment.payerInformation = payer;
        
        subscription.subscriber = ind;
        subscription.correspondenceAddress = add;
        subscription.hccId = '12345';
        
        claim.clearingHouseTraceNumber = '1234567';
        
        claim.subscriptionInformation = subscription;
        
        strList.string_x = new List<String>{'A', 'B'};
        
        rendPract.practitioner = ind;
        totals.memberResponsibilityAmount = 'dummy';
        totals.networkSavings = '123';
        totals.memberPaidAmount = '123';
        totals.requestedAmount = '123';
        totals.hraPaidAmount = '123';
        totals.hccAmount = '123';
        totals.eobPaidAmount = '123';
        totals.eobPaidAmount = '123';
        totals.deductibleAmount = '123';
        totals.copayAmount = '123';
        totals.coinsuranceAmount = '123';
        totals.outNetworkAllowedAmount = '123';
        totals.inNetworkAllowedAmount = '123';
        totals.allowedAmount = '123';
        totals.paidAmount = '123';
        
        claim.attendingInformation = rendPract;
        claim.supplier = supplierClaimInformation;
        claim.reasonForVisitDiagnosis = strList;
        claim.receivedAuthorizationNumber = strList;
        claim.patientInformation = patInfo;
        claim.payToAddress = add;
        claim.claimTotals = totals;
        claim.admissionSource='dummy';
        claim.admissionTypeCode='dummy';
        claim.admitDate = date.today();
        claim.admitDiagnosis='dummy';
        claim.admitTime='dummy';
        claim.allowedAmount='dummy';
        claim.assignmentAcceptance='dummy';
        claim.benefitAssignment='dummy';
        claim.calculatedDRGCode='dummy';
        claim.claimIdentifier=7890;
        claim.clearingHouseTraceNumber = 'dummy';
        claim.dischargeStatus='dummy';
        claim.dischargeTime='dummy';
        claim.endDate=System.today();
        claim.entryDate=System.today();
        claim.externalClaimBatchNumber='dummy';
        claim.externalClaimId='dummy';
        claim.hccAmount='dummy';
        claim.hccId='dummy';
        claim.hospitalizationEndDate=System.today();
        claim.hospitalizationStartDate=System.today();
        claim.inNetwork='dummy';
        claim.informationRelease='dummy';
        claim.interestAmount='dummy';
        claim.medicalRecordNumber='dummy';
        claim.memberAmount='dummy';
        claim.memberPaidAmount='dummy';
        claim.operator='dummy';
        claim.originalSubscriberId='dummy';
        claim.otherHealthBenefitPlanExist=true;
        claim.patientAccountNumber='dummy';
        claim.patientControlNumber='dummy';
        claim.principalDiagnosis='dummy';
        claim.processingDate=System.today();
        claim.providerPenalty='dummy';
        claim.providerSignaturePresent='dummy';
        claim.receiptDate=System.today();
        claim.requestedFeeAmount='dummy';
        claim.reverseEntry=true;
        claim.serviceDateString='dummy';
        claim.startDate=System.today();
        claim.state='dummy';
        claim.submittedDRGCode='dummy';
        claim.supplierInvoiceNumber='dummy';
        claim.supplierReferenceNumber='dummy';
        claim.type_x='dummy';
        claim.typeOfBill='dummy';
        claim.typeOfBillCode='dummy';
        claim.withholdAmount='dummy';
        claimLineOne.claimLine = healthedgeComExtractTest.claimLineList();
        system.debug('@@claimLineList[] claim :'+claimLineOne.claimLine);
        claim.claimLine = claimLineOne;
        system.debug('@@claim.claimLine :'+claim.claimLine);
        claims.add(claim);
        
        claimList.claim = claims;
        
        eobpayment.eobClaimDetail = claimList;
        datetime myDateTime = datetime.now();
        eobpayment.paymentTime = myDateTime;
        eobpayment.paymentStatusDate = date.today();
        eobpayment.paymentNumber = 3;
        eobpayment.paymentDate = date.today();
        eobpayment.paymentBatchNumber = 6;
        system.debug('@@eobpayment :'+eobpayment);
        eobpaymentList.add(eobpayment);
        system.debug('@@eobpaymentList :'+eobpaymentList);
        
        instList.EOBPaymentInformation = eobpaymentList;
        system.debug('@@instList :'+instList);
        
        extpayload.claimExtract = instList;
        system.debug('@@extpayload.claimExtract :'+extpayload);
        
        system.debug('@@extpayload :'+extpayload);
        
        return extpayload;
    }
    
    @isTest
    public static healthEdgeComExtract.extractPayload claim4() {
    
        healthedgeComExtract.claimLineList claimLineOne = new healthedgeComExtract.claimLineList();
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        
        healthEdgeComExtract.extractPayload extpayload = new healthEdgeComExtract.extractPayload();
        healthedgeComExtract.instanceList instList = new healthedgeComExtract.instanceList();
        List<healthedgeComExtract.EOBPaymentInformation> eobpaymentList = new List<healthedgeComExtract.EOBPaymentInformation>();    
        healthedgeComExtract.EOBPaymentInformation eobpayment = new healthedgeComExtract.EOBPaymentInformation();
        healthedgeComExtract.claimList claimList = new healthedgeComExtract.claimList();
        
        List<healthedgeComExtract.claim> claims = new List<healthedgeComExtract.claim>();
        healthedgeComExtract.claim claim = new healthedgeComExtract.claim();
        
        healthedgeComExtract.payer payer = new healthedgeComExtract.payer();
        healthedgeComExtract.address add = new healthedgeComExtract.address();
        healthedgeComExtract.phoneNumber hicPhone = new healthedgeComExtract.phoneNumber();
        
        healthedgeComExtract.patientInformation patInfo = new healthedgeComExtract.patientInformation();
        
        healthedgeComExtract.individual ind = new healthedgeComExtract.individual();
        
        healthedgeComExtract.subscriptionInformation subscription = new healthedgeComExtract.subscriptionInformation();
        
        healthedgeComExtract.stringList strList = new healthedgeComExtract.stringList();
        
        healthedgeComExtract.practitioner rendPract = new healthedgeComExtract.practitioner();
        
        healthedgeComExtract.supplierClaimInformation supplierClaimInformation = new healthedgeComExtract.supplierClaimInformation();
        
        healthedgeComExtract.claimTotals totals = new healthedgeComExtract.claimTotals();
        
        healthedgeComExtract.benefitPlanInformation benefitPlanInformation = new healthedgeComExtract.benefitPlanInformation();
        
        healthedgeComExtract.accumulatorsInformation accumulatorInfo = new healthedgeComExtract.accumulatorsInformation();
        
        healthedgeComExtract.accumulatorList accumList = new healthedgeComExtract.accumulatorList();
        
        healthedgeComExtract.accumulator accum = new healthedgeComExtract.accumulator();
        List<healthedgeComExtract.accumulator> accumListCust = new List<healthedgeComExtract.accumulator>();
        
        accum.amountDefined = '1234';
        accum.amountRemaining = '1234';
        accum.amountUsed = '1234';
        accum.benefitDescription = 'Family Out of Pocket';
        accumListCust.add(accum);
        //Assert to check accumulator is available 
         System.assertNotEquals(null,accum);
        
        accumList.accumulator = accumListCust;
        
        accumulatorInfo.accumulator = accumList;
        
        benefitPlanInformation.endDate = System.today();
        benefitPlanInformation.firstRenewalDate = System.today();
        benefitPlanInformation.hccId = 'dummy';
        benefitPlanInformation.name = 'dummy';
        benefitPlanInformation.planStartDay = 77898;
        benefitPlanInformation.planStartMonth = 'dummy';
        benefitPlanInformation.renewalInterval = 5678;
        benefitPlanInformation.startDate = System.today();
        
        benefitPlanInformation.accumulators = accumulatorInfo;
        
        subscription.benefitPlan = benefitPlanInformation;
        
        supplierClaimInformation.NPI='dummy';
        supplierClaimInformation.TIN='dummy';
        supplierClaimInformation.activeSinceDate=System.today();
        supplierClaimInformation.firstActiveDate=System.today();
        supplierClaimInformation.hccId ='dummy';
        supplierClaimInformation.name='dummy';
        
        ind.nameSuffix = 'suffix';
        ind.namePrefix = 'suffix';
        ind.firstName = 'dummy';
        ind.middleName = 'dummy';
        ind.lastName = 'dummy';
        ind.birthDate = date.today();
        ind.gender = 'male';
        
        add.address = 'dummy';
        add.address2 = 'dummy';
        add.address3 = 'dummy';
        add.city = 'dummy';
        add.stateCode = 'dummy';
        add.zipCode = 'dummy';
        add.zipExtension = 'dummy';
        add.countryCode = 'dummy';
        hicPhone.phoneNumber = '123456';
        
        payer.hicAddress = add;
        payer.hicPhoneNumber = hicPhone;
        patInfo.member = ind;
        patInfo.correspondenceAddress = add;
        patInfo.relationshipToSubscriber = 'dummy';
        eobpayment.payerInformation = payer;
        
        subscription.subscriber = ind;
        subscription.correspondenceAddress = add;
        subscription.hccId = '12345';
        
        claim.clearingHouseTraceNumber = '1234567';
        
        claim.subscriptionInformation = subscription;
        
        strList.string_x = new List<String>{'A', 'B'};
        
        rendPract.practitioner = ind;
        totals.memberResponsibilityAmount = 'dummy';
        totals.networkSavings = '123';
        totals.memberPaidAmount = '123';
        totals.requestedAmount = '123';
        totals.hraPaidAmount = '123';
        totals.hccAmount = '123';
        totals.eobPaidAmount = '123';
        totals.eobPaidAmount = '123';
        totals.deductibleAmount = '123';
        totals.copayAmount = '123';
        totals.coinsuranceAmount = '123';
        totals.outNetworkAllowedAmount = '123';
        totals.inNetworkAllowedAmount = '123';
        totals.allowedAmount = '123';
        totals.paidAmount = '123';
        
        claim.attendingInformation = rendPract;
        claim.supplier = supplierClaimInformation;
        claim.reasonForVisitDiagnosis = strList;
        claim.receivedAuthorizationNumber = strList;
        claim.patientInformation = patInfo;
        claim.payToAddress = add;
        claim.claimTotals = totals;
        claim.admissionSource='dummy';
        claim.admissionTypeCode='dummy';
        claim.admitDate = date.today();
        claim.admitDiagnosis='dummy';
        claim.admitTime='dummy';
        claim.allowedAmount='dummy';
        claim.assignmentAcceptance='dummy';
        claim.benefitAssignment='dummy';
        claim.calculatedDRGCode='dummy';
        claim.claimIdentifier=7890;
        claim.clearingHouseTraceNumber = 'dummy';
        claim.dischargeStatus='dummy';
        claim.dischargeTime='dummy';
        claim.endDate=System.today();
        claim.entryDate=System.today();
        claim.externalClaimBatchNumber='dummy';
        claim.externalClaimId='dummy';
        claim.hccAmount='dummy';
        claim.hccId='dummy';
        claim.hospitalizationEndDate=System.today();
        claim.hospitalizationStartDate=System.today();
        claim.inNetwork='dummy';
        claim.informationRelease='dummy';
        claim.interestAmount='dummy';
        claim.medicalRecordNumber='dummy';
        claim.memberAmount='dummy';
        claim.memberPaidAmount='dummy';
        claim.operator='dummy';
        claim.originalSubscriberId='dummy';
        claim.otherHealthBenefitPlanExist=true;
        claim.patientAccountNumber='dummy';
        claim.patientControlNumber='dummy';
        claim.principalDiagnosis='dummy';
        claim.processingDate=System.today();
        claim.providerPenalty='dummy';
        claim.providerSignaturePresent='dummy';
        claim.receiptDate=System.today();
        claim.requestedFeeAmount='dummy';
        claim.reverseEntry=true;
        claim.serviceDateString='dummy';
        claim.startDate=System.today();
        claim.state='dummy';
        claim.submittedDRGCode='dummy';
        claim.supplierInvoiceNumber='dummy';
        claim.supplierReferenceNumber='dummy';
        claim.type_x='dummy';
        claim.typeOfBill='dummy';
        claim.typeOfBillCode='dummy';
        claim.withholdAmount='dummy';
        claimLineOne.claimLine = healthedgeComExtractTest.claimLineList();
        system.debug('@@claimLineList[] claim :'+claimLineOne.claimLine);
        claim.claimLine = claimLineOne;
        system.debug('@@claim.claimLine :'+claim.claimLine);
        claims.add(claim);
        
        claimList.claim = claims;
        
        eobpayment.eobClaimDetail = claimList;
        datetime myDateTime = datetime.now();
        eobpayment.paymentTime = myDateTime;
        eobpayment.paymentStatusDate = date.today();
        eobpayment.paymentNumber = 3;
        eobpayment.paymentDate = date.today();
        eobpayment.paymentBatchNumber = 6;
        system.debug('@@eobpayment :'+eobpayment);
        eobpaymentList.add(eobpayment);
        system.debug('@@eobpaymentList :'+eobpaymentList);
        
        instList.EOBPaymentInformation = eobpaymentList;
        system.debug('@@instList :'+instList);
        
        extpayload.claimExtract = instList;
        system.debug('@@extpayload.claimExtract :'+extpayload);
        
        system.debug('@@extpayload :'+extpayload);
        
        return extpayload;
    }
    
    @isTest
    public static List<healthedgeComExtract.claimLine> claimLineList() {
        healthedgeComExtract.claimLine claimLine = new healthedgeComExtract.claimLine();
        List<healthedgeComExtract.claimLine> claimLineList = new List<healthedgeComExtract.claimLine>();
        
        healthedgeComExtract.baseBenefitInfo baseBenefit = new healthedgeComExtract.baseBenefitInfo();
        
        healthedgeComExtract.messageMappedList msgMappedList = new healthedgeComExtract.messageMappedList();
        
        List<healthedgeComExtract.messageMapped> msgMapListCust = new List<healthedgeComExtract.messageMapped>();
        healthedgeComExtract.messageMapped msgMapped = new healthedgeComExtract.messageMapped();
        
        healthedgeComExtract.benefitPlanWithProduct benefitPlanWithProd = new healthedgeComExtract.benefitPlanWithProduct();
        
        healthedgeComExtract.product prod = new healthedgeComExtract.product();
        
        healthedgeComExtract.lineOfBusinessList lobList = new healthedgeComExtract.lineOfBusinessList();
        List<healthedgeComExtract.lineOfBusiness> lobListCust = new List<healthedgeComExtract.lineOfBusiness>();
        
        healthedgeComExtract.lineOfBusiness lob = new healthedgeComExtract.lineOfBusiness();
        
        healthedgeComExtract.practitioner rendPract = new healthedgeComExtract.practitioner();
        
        healthedgeComExtract.individual ind = new healthedgeComExtract.individual();
        
        ind.nameSuffix = 'suffix';
        ind.namePrefix = 'suffix';
        ind.firstName = 'dummy';
        ind.middleName = 'dummy';
        ind.lastName = 'dummy';
        rendPract.practitioner = ind;
        
        msgMapped.messageCode = 'dummy';
        msgMapped.messageDescription = 'dummy desc';
        msgMapListCust.add(msgMapped);
        
        msgMappedList.messageMapped = msgMapListCust;
        baseBenefit.claimLineMessages = msgMappedList;
        system.debug('@@msgMappedList :'+ msgMappedList);
        
        claimLine.renderingPractitioner = rendPract;
        claimLine.eobBaseBenefitInfo = baseBenefit;
        system.debug('@@baseBenefit :'+baseBenefit);
        
        lob.lineOfBusinessName = 'dummy';
        lob.groupName = 'dummy';
        lobListCust.add(lob);
        
        lobList.lineOfBusiness = lobListCust;
        prod.linesOfBusiness = lobList;
        prod.planType = 'dummy';
        benefitPlanWithProd.hccId = '1234';
        benefitPlanWithProd.name = 'dummy';
        benefitPlanWithProd.product = prod;
        
        claimLine.baseBenefitPlan = benefitPlanWithProd;
        claimLine.agreementNumber='dummy';
        claimLine.allowedAmount='dummy';
        claimLine.authorizationNumber='dummy';
        claimLine.baseStatus='dummy';
        claimLine.capitated=true;
        claimLine.claimLineId= '4';
        claimLine.cobProcessingConclusion='dummy';
        claimLine.dslStatusCode='dummy';
        claimLine.dslTypeCode='dummy';
        claimLine.emergencyStatus='dummy';
        claimLine.hccAmount='dummy';
        claimLine.hraPaidAmount='dummy';
        claimLine.interestAmount='dummy';
        claimLine.isSplit=true;
        claimLine.memberPaidAmount='dummy';
        claimLine.memberResponsibility='dummy';
        claimLine.minuteCount=67889;
        claimLine.networkTierCode='dummy';
        claimLine.networkTierName='dummy';
        claimLine.nonCoveredCharges='dummy';
        claimLine.originalLineNumber='dummy';
        claimLine.paidAmount='dummy';
        claimLine.placeOfService='dummy';
        claimLine.providerPenalty='dummy';
        claimLine.providerWriteOff='dummy';
        claimLine.requestedAmount='dummy';
        claimLine.revenueCode='dummy';
        claimLine.revenueCodeDesc='dummy';
        claimLine.serviceCode='dummy';
        claimLine.serviceCodeDesc='dummy';
        claimLine.serviceEndDate=System.today();
        claimLine.serviceStartDate=System.today() ;
        claimLine.units=898.889;
        claimLineList.add(claimLine);
        
        //Assert to check claimLine is available 
         System.assertNotEquals(null,claimLine);
        system.debug('@@claimLineList :'+claimLineList);
        return claimLineList;
    }
    
    
       @isTest
       public static void Method2()  
       {
        healthedgeComExtract.UB92MemberInformation UB92MemberInformation = new healthedgeComExtract.UB92MemberInformation();
        healthedgeComExtract.pricingInfo pricingInfo = new healthedgeComExtract.pricingInfo();
        pricingInfo.adjustedAllowedAmount='dummy';
        pricingInfo.isContracted=true;
        pricingInfo.nonPar=true;
        
        
        healthedgeComExtract.UB92SupplierInformation  UB92SupplierInformation = new healthedgeComExtract.UB92SupplierInformation();
        UB92SupplierInformation.faxNumber='dummy';
        UB92SupplierInformation.npi='dummy';
        UB92SupplierInformation.supplierName='dummy';
        UB92SupplierInformation.taxIdentificationNumber='dummy';
        UB92SupplierInformation.telephoneNumber='dummy';
        
        //Assert to check UB92SupplierInformation is available 
         System.assertNotEquals(null,UB92SupplierInformation);
       }
        @isTest
       public static void claimTotals()  
       {
        healthedgeComExtract.claimTotals  claimTotals = new healthedgeComExtract.claimTotals();
        claimTotals.allowedAmount='dummy';
        claimTotals.coinsuranceAmount='dummy';
        claimTotals.copayAmount='dummy';
        claimTotals.deductibleAmount='dummy';
        claimTotals.eobPaidAmount='dummy';
        claimTotals.hccAmount='dummy';
        claimTotals.hraPaidAmount='dummy';
        claimTotals.inNetworkAllowedAmount='dummy';
        claimTotals.memberPaidAmount='dummy';
        claimTotals.memberResponsibilityAmount='dummy';
        claimTotals.networkSavings='dummy';
        claimTotals.nonCoveredCharges='dummy';
        claimTotals.outNetworkAllowedAmount='dummy';
        claimTotals.paidAmount='dummy';
        claimTotals.requestedAmount='dummy';
        
        //Assert to check claimTotals is available 
         System.assertNotEquals(null,claimTotals);
    }
     @isTest
       public static void benefitInfo()  
       {
        healthedgeComExtract.benefitInfo  benefitInfo = new healthedgeComExtract.benefitInfo();
        benefitInfo.balanceBillMemberExcess='dummy';
        benefitInfo.coInsuranceAmount='dummy';
        benefitInfo.coPayAmount='dummy';
        benefitInfo.deductibleAmount='dummy';
        benefitInfo.hccAmount='dummy';
        benefitInfo.memberPaidAmount='dummy';
        benefitInfo.memberPenalty='dummy';
        benefitInfo.memberResponsibilityAmount='dummy';
        benefitInfo.nonCoveredMemberExcess='dummy';
        benefitInfo.paidAmount='dummy';
        benefitInfo.paidAmountIncludedInAggregatingPaymentDetails=true;
        
        //Assert to check benefitInfo is available 
         System.assertNotEquals(null,benefitInfo);
        
        }
       @isTest
       public static void product()  
       {
        healthedgeComExtract.product  product= new healthedgeComExtract.product(); 
        
        product.category='dummy';
        product.isMedicare=true;
        product.planType='dummy';
        product.productId='dummy';
        product.productName='dummy';
        
        //Assert to check product is available 
         System.assertNotEquals(null,product);
        }
         @isTest
       public static void NDCCode()  
       {
        healthedgeComExtract.NDCCode  NDCCode= new healthedgeComExtract.NDCCode();
        NDCCode.measurementType='dummy';
        NDCCode.ndcCode='dummy';
        NDCCode.quantity='dummy'; 
        
        //Assert to check NDCCode is available 
         System.assertNotEquals(null,NDCCode);
        }
        @isTest
       public static void baseBenefitInfo ()  
       {
        healthedgeComExtract.baseBenefitInfo  baseBenefitInfo = new healthedgeComExtract.baseBenefitInfo();
        baseBenefitInfo.deniedClaim=true;
        baseBenefitInfo.messageCodeString='dummy';
        baseBenefitInfo.networkSavings='dummy';
        baseBenefitInfo.nonPar=true;
        baseBenefitInfo.serviceDate='dummy';
        baseBenefitInfo.status='dummy';
        
        //Assert to check baseBenefitInfo is available 
         System.assertNotEquals(null,baseBenefitInfo);
        }
  
       @isTest
       public static void benefitPlanWithProduct ()  
       {
       healthedgeComExtract.benefitPlanWithProduct benefitPlanWithProduct = new healthedgeComExtract.benefitPlanWithProduct();
        benefitPlanWithProduct.endDate=System.today();
        benefitPlanWithProduct.firstRenewalDate=System.today();
        benefitPlanWithProduct.hccId='dummy';
        benefitPlanWithProduct.name='dummy';
        benefitPlanWithProduct.planStartDay=57788;
        benefitPlanWithProduct.planStartMonth='dummy';
        benefitPlanWithProduct.renewalInterval=6788;
        benefitPlanWithProduct.startDate=System.today();
        
        //Assert to check benefitPlanWithProduct is available 
         System.assertNotEquals(null,benefitPlanWithProduct);
       }
        @isTest
        public static void  benefitPlanInformation(){
            healthedgeComExtract.benefitPlanInformation benefitPlanInformation = new healthedgeComExtract.benefitPlanInformation();
            benefitPlanInformation.endDate = System.today();
            benefitPlanInformation.firstRenewalDate = System.today();
            benefitPlanInformation.hccId = 'dummy';
            benefitPlanInformation.name = 'dummy';
            benefitPlanInformation.planStartDay = 77898;
            benefitPlanInformation.planStartMonth = 'dummy';
            benefitPlanInformation.renewalInterval = 5678;
            benefitPlanInformation.startDate = System.today();
            
            //Assert to check benefitPlanInformation is available 
         System.assertNotEquals(null,benefitPlanInformation);
        }
        
        @isTest
       public static void payer()  
       {
       healthedgeComExtract.payer  payer = new healthedgeComExtract.payer();
        payer.hicName='dummy';
        payer.taxId='dummy';
        
        //Assert to check payer is available 
         System.assertNotEquals(null,payer);
        }
        @isTest
       public static void otherInsuranceClaimInfo()  
       {
       healthedgeComExtract.otherInsuranceClaimInfo  otherInsuranceClaimInfo = new healthedgeComExtract.otherInsuranceClaimInfo();
        otherInsuranceClaimInfo.acceptsAssignment=true;
        otherInsuranceClaimInfo.authorizationNumber='dummy';
        otherInsuranceClaimInfo.companyName='dummy';
        otherInsuranceClaimInfo.employerName='dummy';
        otherInsuranceClaimInfo.employmentStatus='dummy';
        otherInsuranceClaimInfo.estimatedDueAmount='dummy';
        otherInsuranceClaimInfo.groupName='dummy';
        otherInsuranceClaimInfo.groupNumber='dummy';
        otherInsuranceClaimInfo.otherInsuranceClaimInfoIdentifier=76789;
        otherInsuranceClaimInfo.otherInsuranceSubscriberId='dummy';
        otherInsuranceClaimInfo.otherInsuranceSubscriberName='dummy';
        otherInsuranceClaimInfo.providerNumber='dummy';
        otherInsuranceClaimInfo.relationshipToSubscriberCode='dummy';
        otherInsuranceClaimInfo.releaseBenefits=true;
        otherInsuranceClaimInfo.subscriberDOB=System.today();
        otherInsuranceClaimInfo.subscriberGender='dummy';
        
        //Assert to check otherInsuranceClaimInfo is available 
         System.assertNotEquals(null,otherInsuranceClaimInfo);
        }
        
       @isTest
       public static void hierarchicalAccountInformation()  
       {
       healthedgeComExtract.hierarchicalAccountInformation hierarchicalAccountInformation = new healthedgeComExtract.hierarchicalAccountInformation();
        hierarchicalAccountInformation.accountType='dummy';
        hierarchicalAccountInformation.accountTypeCode='dummy';
        hierarchicalAccountInformation.id='dummy';
        hierarchicalAccountInformation.name='dummy';
        hierarchicalAccountInformation.parentAccountId='dummy';
        hierarchicalAccountInformation.parentAccountType='dummy';
        hierarchicalAccountInformation.parentAccountTypeCode='dummy';
        hierarchicalAccountInformation.startDate=System.today();
        hierarchicalAccountInformation.systemId=787989;
        hierarchicalAccountInformation.taxId='dummy';
        hierarchicalAccountInformation.topAccountId='dummy';
        hierarchicalAccountInformation.topAccountName='dummy';
        hierarchicalAccountInformation.topAccountType='dummy';
        hierarchicalAccountInformation.topAccountTypeCode='dummy';
        
        //Assert to check hierarchicalAccountInformation is available 
         System.assertNotEquals(null,hierarchicalAccountInformation);
        }
       @isTest
       public static void address()  
       {
       healthedgeComExtract.address address = new healthedgeComExtract.address();
        address.address='dummy';
        address.address2='dummy';
        address.address3='dummy';
        address.city='dummy';
        address.countryCode='dummy';
        address.countyCode='dummy';
        address.stateCode='dummy';
        address.zipCode='dummy';
        address.zipExtension='dummy';
        
        //Assert to check address is available 
         System.assertNotEquals(null,address);
        }
       
          
       @isTest
       public static void identificationNumber()  
       {
        healthedgeComExtract.identificationNumber identificationNumber = new healthedgeComExtract.identificationNumber();
        identificationNumber.endDate=System.today();
        identificationNumber.idNumber='dummy';
        identificationNumber.idType='dummy';
        identificationNumber.idTypeCode='dummy';
        identificationNumber.issuingState='dummy';
       identificationNumber.startDate=System.today();
       
       
       //Assert to check identificationNumber is available 
         System.assertNotEquals(null,identificationNumber);
       }       
       @isTest
       public static void contact()  
       {
        healthedgeComExtract.contact contact = new healthedgeComExtract.contact();
        contact.contactType='dummy';
        contact.email='dummy';
        contact.firstName='dummy';
        contact.lastName='dummy';
        contact.middleName='dummy';
        contact.prefix='dummy';
        contact.suffix='dummy';
        contact.title='dummy';
        
        //Assert to check contact is available 
         System.assertNotEquals(null,contact);
        }
        @isTest
       public static void account ()  
       {
        healthedgeComExtract.account  account = new healthedgeComExtract.account ();
        account.accountType='dummy';
        account.accountTypeCode='dummy';
        account.id='dummy';
        account.name='dummy';
        account.startDate=System.today();
        account.systemId=67899;
        account.taxId='dummy';
        
        //Assert to check account is available 
         System.assertNotEquals(null,account);
        }
       @isTest
       public static void  EOBInfo  ()  
       {
        healthedgeComExtract.EOBInfo   EOBInfo  = new healthedgeComExtract.EOBInfo ();
        EOBInfo.eobAllowedAmount='dummy';
        EOBInfo.eobBilledAmount='dummy';
        EOBInfo.eobCoinsuranceAmount='dummy';
        EOBInfo.eobCompanyName='dummy';
        EOBInfo.eobCopayAmount='dummy';
        EOBInfo.eobDeductibleAmount='dummy';
        EOBInfo.eobDiscountAmount='dummy';
        EOBInfo.eobMemberPenalty='dummy';
        EOBInfo.eobMemberResponsibilityAmount='dummy';
        EOBInfo.eobNonCoveredAmount='dummy';
        EOBInfo.eobPaidAmount='dummy';
        EOBInfo.eobProviderPenalty='dummy';
        
        //Assert to check EOBInfo is available 
         System.assertNotEquals(null,EOBInfo);
        }
        
           @isTest
       public static void   individual  ()  
       {
        healthedgeComExtract.individual  individual= new healthedgeComExtract.individual ();
        individual.birthDate=System.today();
        individual.deceasedDate=System.today();
        individual.firstName='dummy';
        individual.gender='dummy';
        individual.genderCode='dummy';
        individual.lastName='dummy';
        individual.maritalStatus='dummy';
        individual.maritalStatusCode='dummy';
        individual.middleName='dummy';
        individual.namePrefix='dummy';
        individual.nameSuffix='dummy';
        individual.ssn='dummy';
        
        //Assert to check individual is available 
         System.assertNotEquals(null,individual);
        }
        @isTest
        public static void   accumulator  ()  
       {
        healthedgeComExtract.accumulator  accumulator =new healthedgeComExtract.accumulator ();
        accumulator.amountDefined='dummy';
        accumulator.amountRemaining='dummy';
        accumulator.amountUsed='dummy';
        accumulator.benefitDescription='dummy';
        accumulator.boundType='diummy';
        accumulator.effectiveRange='dummy';
        accumulator.provision='dummy';
        accumulator.tier='dummy';
        
        //Assert to check accumulator is available 
         System.assertNotEquals(null,accumulator);
        }
       @isTest  
       public static void   attribute  ()  
       {
        healthedgeComExtract.attribute attribute =new healthedgeComExtract.attribute  ();
        attribute.attributeName='dummy';
        attribute.defaultValue='dummy';
        attribute.longName='dummy';
        attribute.value='dummy';
        attribute.valueShortName='dummy';
        
        //Assert to check attribute is available 
         System.assertNotEquals(null,attribute);
        }
        @isTest
        public static void   HCFA1500SupplierInformation  ()  
       {
        healthedgeComExtract.HCFA1500SupplierInformation HCFA1500SupplierInformation=new healthedgeComExtract.HCFA1500SupplierInformation();
        HCFA1500SupplierInformation.assignmentAcceptance='dummy';
        HCFA1500SupplierInformation.faxNumber='dummy';
        HCFA1500SupplierInformation.groupNumber='dummy';
        HCFA1500SupplierInformation.npi='dummy';
        HCFA1500SupplierInformation.otherId='dummy';
        HCFA1500SupplierInformation.supplierBillingName='dummy';
        HCFA1500SupplierInformation.supplierPINNumber='dummy';
        HCFA1500SupplierInformation.taxIdCode='dummy';
        HCFA1500SupplierInformation.taxIdentificationNumber='dummy';
        HCFA1500SupplierInformation.telephoneNumber='dummy';
        
        //Assert to check HCFA1500SupplierInformation is available 
         System.assertNotEquals(null,HCFA1500SupplierInformation);
        
        }
        @isTest
        public static void   Method3()  
       {
        healthedgeComExtract.reviewTrigger  reviewTrigger =new healthedgeComExtract.reviewTrigger();
        reviewTrigger.approved=true;
       
        healthedgeComExtract.occurrenceCode  occurrenceCode=new healthedgeComExtract.occurrenceCode();
        occurrenceCode.occurrenceCode='dummy';
        occurrenceCode.prEndDate=System.today();
        occurrenceCode.prStartDate=System.today();
        healthedgeComExtract.messageMappedList   messageMappedList =new healthedgeComExtract.messageMappedList();
        
        healthedgeComExtract.ingenixFlagList   ingenixFlagList =new healthedgeComExtract.ingenixFlagList();
        
        healthedgeComExtract.claimLineList   claimLineList  =new healthedgeComExtract.claimLineList();
        healthedgeComExtract.subAccountInformation   subAccountInformation =new healthedgeComExtract.subAccountInformation();
        subAccountInformation.id='dummy';
        subAccountInformation.name='dummy';
        
        healthedgeComExtract.diagnosisInfo   diagnosisInfo  =new healthedgeComExtract.diagnosisInfo();
        diagnosisInfo.diagnosisCode='dummy';
        diagnosisInfo.poaIndicator='dummy';
        
        healthedgeComExtract.dentalPatientInformation   dentalPatientInformation =new healthedgeComExtract.dentalPatientInformation();
        healthedgeComExtract.reviewTriggerList     reviewTriggerList  =new healthedgeComExtract.reviewTriggerList();
        healthedgeComExtract.fundedAccount     fundedAccount  =new healthedgeComExtract.fundedAccount();
        fundedAccount.accountId='dummy';
        fundedAccount.accountType='dummy';
        fundedAccount.asOf=System.today();
        fundedAccount.fundedAmount='dummy';
        fundedAccount.remainingAmount='dummy';
        fundedAccount.usedAmount='dummy';
        
         healthedgeComExtract.instanceList   instanceList=new healthedgeComExtract.instanceList();
        instanceList.extractId='dummy';
        instanceList.extractReason='dummy';
        instanceList.extractTime=System.today();
        instanceList.extractType='dummy';
                        
        healthedgeComExtract.UDT    UDT =new healthedgeComExtract.UDT();
        UDT.udtName='dummy';
        
        healthedgeComExtract.UB92Info     UB92Info   =new healthedgeComExtract.UB92Info ();
        healthedgeComExtract.supplierLocation     supplierLocation    =new healthedgeComExtract.supplierLocation  ();
         
        supplierLocation.NPI='dummy';
        supplierLocation.hccId='dummy';
        supplierLocation.name='dummy';
        
        healthedgeComExtract.dentalSupplierInvoiceInfo   dentalSupplierInvoiceInfo   =new healthedgeComExtract.dentalSupplierInvoiceInfo ();
        healthedgeComExtract.dentalClaimInfo     dentalClaimInfo   =new healthedgeComExtract.dentalClaimInfo();
        dentalClaimInfo.typeOfTransaction='dummy';
        
        healthedgeComExtract.attributeList    attributeList  =new healthedgeComExtract.attributeList();
        
        healthedgeComExtract.name   name  =new healthedgeComExtract.name();
        name.firstName='dummy';
        name.lastName='dummy';
        name.middleName='dummy';
        name.prefix='dummy';
        name.suffix='dummy';
        
        healthedgeComExtract.patientInformation patientInformation  =new healthedgeComExtract.patientInformation();
        patientInformation.hccId='dummy';
        patientInformation.relationshipToSubscriber='dummy';
        patientInformation.relationshipToSubscriberCode='dummy';
        
        healthedgeComExtract.externalPricerResult  externalPricerResult   =new healthedgeComExtract.externalPricerResult ();
        externalPricerResult.drgWeight='dummy';
        healthedgeComExtract.accumulatorList accumulatorList =new healthedgeComExtract.accumulatorList();
        healthedgeComExtract.procedureList procedureList =new healthedgeComExtract.procedureList();
        healthedgeComExtract.contactList contactList =new healthedgeComExtract.contactList();
        
        healthedgeComExtract.HCFA1500MemberInformation  HCFA1500MemberInformation =new healthedgeComExtract.HCFA1500MemberInformation();
        healthedgeComExtract.wrapAroundBenefitInfoList wrapAroundBenefitInfoList =new healthedgeComExtract.wrapAroundBenefitInfoList();
        healthedgeComExtract.HCFA1500SubscriberInformation  HCFA1500SubscriberInformation  =new healthedgeComExtract.HCFA1500SubscriberInformation ();
        healthedgeComExtract.repricerInformationList   repricerInformationList  =new healthedgeComExtract.repricerInformationList ();
        healthedgeComExtract.DRG DRG =new healthedgeComExtract.DRG();
        DRG.drgCode='dummy';
        DRG.relativeWeight=89.90;
        healthedgeComExtract.facilityInformation  facilityInformation  =new healthedgeComExtract.facilityInformation ();
        facilityInformation.facilityName='dummy1';
        facilityInformation.npi='dummy1';
        facilityInformation.otherId='dmmy';
        facilityInformation.telephoneNumber='dummy';
        
        healthedgeComExtract.message   message =new healthedgeComExtract.message ();
        message.codeDomainName='dummy';
        message.messageCode='dummy';
        message.messageDescription='dummy';
        
        healthedgeComExtract.paymentRequestValueCode paymentRequestValueCode  =new healthedgeComExtract.paymentRequestValueCode ();
        paymentRequestValueCode.amount=89.89;
        paymentRequestValueCode.valueCode='dummy';
        
        //Assert to check paymentRequestValueCode is available 
         System.assertNotEquals(null,paymentRequestValueCode);
        
        healthedgeComExtract.extractPayload  extractPayload   =new healthedgeComExtract.extractPayload  ();
        healthedgeComExtract.wrapAroundBenefitInfo   wrapAroundBenefitInfo    =new healthedgeComExtract.wrapAroundBenefitInfo   ();
        wrapAroundBenefitInfo.benefitPlanName='dummy';
        wrapAroundBenefitInfo.nonPar=true;
        wrapAroundBenefitInfo.planType='dummy';
        wrapAroundBenefitInfo.statusCode='dummy';
        
        healthedgeComExtract.benefitNetworkInformation   benefitNetworkInformation   =new healthedgeComExtract.benefitNetworkInformation  ();
        benefitNetworkInformation.benefitNetworkName='dummy';
        
        healthedgeComExtract.practitionerList  practitionerList  =new healthedgeComExtract.practitionerList  ();
        healthedgeComExtract.stringList   stringList   =new healthedgeComExtract.stringList  ();
        
        healthedgeComExtract.activityExceptionWS  activityExceptionWS  =new healthedgeComExtract.activityExceptionWS  ();
        healthedgeComExtract.HCFA1500Info   HCFA1500Info   =new healthedgeComExtract.HCFA1500Info ();
        
        healthedgeComExtract.procedure   procedure   =new healthedgeComExtract.procedure ();
        
        
        healthedgeComExtract.specialtyInformation specialtyInformation =new healthedgeComExtract.specialtyInformation  ();
        healthedgeComExtract.reportingCategory  reportingCategory   =new healthedgeComExtract.reportingCategory ();
        
        healthedgeComExtract.occurrenceCodeList  occurrenceCodeList  =new healthedgeComExtract.occurrenceCodeList();
        healthedgeComExtract.otherInsuranceClaimInfoList   otherInsuranceClaimInfoList   =new healthedgeComExtract.otherInsuranceClaimInfoList ();
        
        healthedgeComExtract.claimList claimList  =new healthedgeComExtract.claimList ();

        }     
  }