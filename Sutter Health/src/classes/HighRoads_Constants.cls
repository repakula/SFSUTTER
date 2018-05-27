/**********************************************************************
Version     Name              Date          Details
1.0        Deloitte           02-17-2017    SHP10 SHPRiderHDHP
2.0        Deloitte           16-03-2017    SHP15 Moifieed query
3.0        Deloitte           03-05-2017    SHP44 Added below constants
                                            1. SHP_CURRENTTIER1_BLANKMSG
                                            2. SHP_CURRENTTIER1_ZEROMSG      
**********************************************************************/
public class HighRoads_Constants {
    public static final string OPPOBJNAME = 'Opportunity';
    public static final string RFPOBJNAME = 'RFP';
    public static final string QUOTEOBJNAME = 'Quote';
    public static final string SSOOBJNAME = 'SSO';
    public static final string SCNOBJNAME = 'SCN';
    public static final string RSO = 'RSO';
    public static final string TEMPLATE_NAME = 'Custom_Benefit_Plan_Sold';
    public static final string TEMPLATE_TYPE = 'html';
    public static final string STATIC_STRING_IN_TEMPLATE = '#CUSTOM_PLAN#';
    public static final string BPA_GROUP_NAME = 'SHP BPA Doc.Gen.Group';
    public static final string NEW_LINE = '\n';
    public static final string RFP_API_NAME = 'RFP_Form__c';
    public static final string QUOTE_API_NAME = 'Quote__c';
    public static final string SSO_API_NAME = 'Sold_Sign_Off__c';
    public static final string SCN_API_NAME ='Sold_Case_Notification__c';
    public static final string SELECT_ID = 'SELECT ID,';
    public static final string FROM_PART_BPM = ' FROM Benefit_Plan_Metadata__c where ID IN :metaDataIds';
    public static final string FROM_PART_CBP = ' FROM Custom_Benefit_Plan__c where id IN :approvedCustomPlanIds';
    public static final string COMMA = ',';
    public static final string STATUS_NEW = 'New';
    public static final string TYPE_CUSTOM = 'Custom';
    public static final string SOFT_APPROVAL_REC_TYPE_NAME = 'Soft Approval';
    public static final string UNDERSCORE = '_';
    public static final string FROM_PART_CBP_1 = ' FROM Custom_Benefit_Plan__c where id IN :updatedCustomPlans';
    public static final string ACCOUNTID = 'accountId';
    public static final string FWRD_SLASH = '/';
    public static final string BLANK_VALUE = '';
    public static final string MEDICAL = 'Medical';
    public static final string RIDER = 'Rider';
    public static final string RECORD_ID = 'recordId';
    public static final string ACTIVE_GROUP_NAME = 'Active';
    public static final string EARLY_RETIREE_GROUP_NAME = 'Early Retiree';
    public static final string OPP_API_NAME = 'Opportunity__c';
    public static final string INCUMBENT_CARRIER_API_NAME = 'Incumbent_Carrier__c';
    public static final string PROPOSAL_API_NAME = 'Proposal__c';
    public static final string EMPLOYER_GROUP_DATA_API_NAME = 'Employer_Group_Data__c';
    public static final string DENTAL = 'Dental';
    public static final string OTHER_1 = 'Other1';
    public static final string OTHER_2 = 'Other2';
    public static final string OTHER_3 = 'Other3';
    public static final string OTHER_4 = 'Other4';
    public static final string OTHER_5 = 'Other5';
    public static final string OTHER_6 = 'Other6';
    public static final string OTHER_7 = 'Other7';
    public static final string OTHER_8 = 'Other8';
    public static final string OTHER_9 = 'Other9';
    public static final string OTHER_10 = 'Other10';
    public static final string TIER_1 = 'Tier 1';
    public static final string TIER_2 = 'Tier 2';
    public static final string TIER_3 = 'Tier 3';
    public static final string TIER_4 = 'Tier 4';
    public static final string TIER_5 = 'Tier 5';
    public static final string WINDOW_CLOSE = 'javascript:window.close();';
    public static final string SYMBOL_ASH = '#';
    public static final string NEW_LINE_HTML = '<Br/>';
    public static final string SFDCID = 'Id';
    public static final string HYPHEN = '-';
    public static final string EXISTING_BUSINESS = 'Existing Business';
    public static final string QUOTE_ID = 'quoteId';
    public static final string SSO_ID = 'ssoId';
    public static final string EMPLOYER_TYPE = 'employerType';
    //SHP-15 Custom plan button is not working 
    public static final string MEDICAL_PLAN_QUERY = 'SELECT ID,Benefit_Grid__c,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,IsActivelyMarketed__c,Plan_Related_to_Account__c,Name,Plan_Name__c,Deductible__c,Family_Deductible__c,Ind_Family_Deductible__c,DOV__c,Inpatient__c,Emergency_Room__c,'
                                                    +'IsCustom__c,IsHDHP__c, IsHMO__c, Office_Visit__c,Out_of_Pocket_Maximum__c,Family_OOPM__c,Ind_Family_OOPM__c,Product_Family__c,Outpatient__c,Product__c,'
                                                    +'RX_Tier_1__c,RX_Tier_2__c,RX_Tier_3__c,RX_Tier_4__c,Rx_Deductible_Family__c,Rx_Deductible_Ind_Family__c,Rx_Deductible_Individual__c,Specialist_Office_Visit__c,Plan_Type__c,Product_Types__c'
                                                    +' FROM Benefit_Plan_Metadata__c WHERE Medical_OR_Rider__c ='+'\''+System.Label.HR42_Medical+'\''+' AND '
                                                    +'(Plan_Type__c IN ('+'\''+System.Label.HR48_Standard+'\''+','+'\''+System.Label.HR49_Custom+'\''+')'+' OR (Plan_Related_to_Account__c = '+'\'';
    public static final string MEDICAL_PLAN_QUERY_1 = '\''+' AND isCustom__c = true ))';
    public static final string AND_CONDITION_WITH_SPACE = ' AND ';
    public static final string MEDICAL_PLAN_QEURY_2 = ' Order by Benefit_Plan_ID__c';
    public static final string SEARCH_INPUT_LENGTH_MSG = 'Please enter atleast 3 characters for search';
    public static final string WHERE_PART_QUERY = 'SELECT Account_RecordType_Name__c,';
    public static final string FROM_KEY_WORD = ' from ';
    public static final string WHERE_PART_QUERY_1 = ' where id=:recordId LIMIT 1';
    public static final string EQUALS_SYMBOL = '=';
    public static final string SINGLE_SPACE = ' ';
    public static final string BACK_SLASH = '\'';
    public static final string LEFT_BRACKET = '(';
    public static final string RIGHT_BRACKET = ')';
    public static final string EMPLOYER_TYPE_API = 'Employer_Type__c';
    public static final string NA_IN_QUERY = ',\'N/A\')';
    public static final string ACC_REC_TYPE_API = 'Account_RecordType_Name__c';
    public static final string INCLUDES_KEY_WORD = 'INCLUDES';
    public static final string IN_KEY_WORD = 'IN';
    public static final string EXISTING_PLAN_QUERY = 'SELECT Benefit_Plan_Metadata__c,Raider_ID__c FROM Benefit_Plan_Association__c WHERE ';
    public static final string EXISTING_PLAN_QUERY_1 = 'Raider_ID__c = NULL';
    public static final string EXISTING_PLAN_QUERY_2 = 'Raider_ID__c != NULL';
    public static final string NOT_EXISTING_PLAN_QUERY = 'SELECT ID,Name,EOC__c ,SBC__c ,BCM__c ,Ancillary_EOC__c ,Ancillary_SOB__c ,Ancillary_GSA__c,Version_Number__c,Benefit_Plan_ID__c,Plan_Name__c,Visit_Limit__c,Rider_Cost_Share__c,Product_Class__c '
                                                            +'FROM Benefit_Plan_Metadata__c WHERE Plan_Status__c not in (\'Pending Approval by DMHC - Not Available for Sale\', \'Not Approved by DMHC - Not Available for Sale\') AND Medical_OR_Rider__c = '+'\''+System.Label.HR43_Rider+'\''
                                                            +'AND ID NOT IN :existingRiderIds AND (Plan_Related_to_Account__c = '+'\'';
    public static final string NOT_EXISTING_PLAN_QEURY_1 = '\''+' OR Plan_Related_to_Account__c = NULL)';
    public static final string NOT_EXISTING_PLAN_QEURY_HDHP = ' AND isHDHP__c ';
    public static final string NOT_EXISTING_PLAN_QEURY_HMO = ' AND isHMO__c ';
    public static final string EQUALS_TRUE = '=True';
    public static final string EQUALS_FALSE = '=False';
    public static final string QUEUE = 'Queue';
    public static final string NA_VALUE = 'N/A';
    public static final string GROUP_VALUE = 'Group';
    public static final string TAB_NEWLINE = '\r\n';
    public static final string PORTFOLIO_OBJ_API_NAME = 'SHP_Benefit_Grid__c';
    public static final string MODIFIED_ON = ' modified on ';
    public static final string SUMMARY_OF_CHANGES = 'Summary of changes: ';
    public static final string FROM_VALUE =  ': From "';
    public static final string TO_VALUE = '" To "';
    public static final string DOUBLE_QUOTE = '"';
    public static final string CUSTOM_BENEFIT_PLAN_API_NAME = 'Custom_Benefit_Plan__c';
    public static final string PLAN_STATUS_API = 'Plan_Status__c';
    public static final string BPA_INTERNAL_STATUS_API = 'BPA_Internal_Status__c';
    public static final string GRID_QUERY_FOR_CUSTOM_PLAN = ' FROM SHP_Benefit_Grid__c where ID IN :gridIds';
    public static final string SELECT_STRING = 'SELECT ';
    public static final string COLON = ':';
    public static final string OBJ_NAME_CONSTANT = '#OBJ_NAME#';
    public static final string EMP_DBA_CONSTANT = '#EMP_DBA#';
    public static final string EMP_NAME_CONSTANT = 'Employer Name:';
    public static final string DBA_CONSTANT = '/DBA:';
    public static final string BPA_ADMIN_QUEUE = 'Benefit_Plan_Admin_Queue';
    public static final string SHP_SALES_PROFILE = 'SHP Sales';
    public static final string SHP_Benefit_Plan_Administration = 'SHP Benefit Plan Administration';
    public static final string CUSTOM_BENEFIT_PLAN_NAME = '{!Custom_Benefit_Plan__c.Name}';
    public static final string ERRORVFC45 = 'Cannot set the value of current rates to empty/zero';
    public static final string HREF = '<a href="';
    public static final string GTR_THAN = '">';
    public static final string ANCHOR_CLOSE = '</a>';
    public static final string PLAN_RELATED_TO_ACC = '{!Custom_Benefit_Plan__c.Plan_Related_to_Account__c}';
    public static final string PLAN_DBA = '{!Custom_Benefit_Plan__c.DBA__c}';
    public static final string PLAN_EMP_TYPE = '{!Custom_Benefit_Plan__c.Employer_Type__c}';
    public static final string TIER1_ERROR_MSG = 'Cannot set the value of current rates to zero';
    public static final string SHP_CURRENTTIER1_BLANKMSG = 'Can not leave value as BLANK for Current Tier ';
    public static final string SHP_CURRENTTIER1_ZEROMSG = 'Can not leave value as ZERO for Current Tier ';
}