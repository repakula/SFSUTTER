<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Account_Owner_when_Opp_Close_Date_is_less_than_7_Days_away</fullName>
        <description>Email Account Owner when Opp Close Date is less than 7 Days away</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Opp_Close_Date_7_days_away</template>
    </alerts>
    <alerts>
        <fullName>Email_Remainder_RFP_due_Date</fullName>
        <description>Email Remainder RFP due Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Opportunity_Owner_If_Status_is_Closed_Lost_and_RFP_Due_Date_is_less_than_270_day</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_when_Opportunity_stage_is_set_to_Closed_Won</fullName>
        <ccEmails>shpsales@sutterhealth.org</ccEmails>
        <description>Email alert when Opportunity stage is set to Closed Won</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Sold_Opportunity_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify</fullName>
        <description>Notify SHP users of converted Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHMMN_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/New_converted_opportunity_New</template>
    </alerts>
    <alerts>
        <fullName>Notify_SHMMN_users_of_opportunities_shared_with_them</fullName>
        <description>Notify SHMMN users of opportunities shared with them</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHMMN_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/SHP_Shared_Oppty</template>
    </alerts>
    <alerts>
        <fullName>Notify_Sales_Team_about_renewed_Opportunity</fullName>
        <description>Notify Sales Team about renewed Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Renewal_Opportunity_Created</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Closed_Won</fullName>
        <description>Opportunity Closed Won</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Opportunity_Closed_Won_SCN</template>
    </alerts>
    <alerts>
        <fullName>SHMMN_Shared_Opportunity_not_accepted_from_1_day</fullName>
        <description>SHMMN Shared Opportunity not accepted from 1 day</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/One_Day_Not_Accepted_SHMMN_Shared_Opportunity_New</template>
    </alerts>
    <alerts>
        <fullName>SHMMN_Shared_Opportunity_not_accepted_from_2_day</fullName>
        <description>SHMMN Shared Opportunity not accepted from 2 day</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>VP_Sales_Marketing</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/Two_Day_Not_Accepted_SHMMN_Shared_Opportunity_New</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Status_to_Proposal</fullName>
        <field>Status__c</field>
        <literalValue>Proposal</literalValue>
        <name>Account Status to Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Updated_to_Sold</fullName>
        <field>Status__c</field>
        <literalValue>Sold</literalValue>
        <name>Account Updated to Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Days_to_close</fullName>
        <field>Days_taken_to_close__c</field>
        <formula>ABS(ROUND( 9 * ( 
( 5 * FLOOR( ( TODAY() - DATE( 1996, 1, 1) ) / 7) + 
MIN(5, 
MOD( TODAY() - DATE( 1996, 1, 1), 7) + 
MIN( 1, 24 / 9 * ( MOD(NOW() - DATETIMEVALUE( &apos;1996-01-01 15:00:00&apos; ), 1 ) ) ) 
) 
) 
- 
( 5 * FLOOR( ( DATEVALUE( CreatedDate ) - DATE( 1996, 1, 1) ) / 7) + 
MIN( 5, 
MOD( DATEVALUE( CreatedDate ) - DATE( 1996, 1, 1), 7 ) + 
MIN( 1, 24 / 9 * ( MOD( CreatedDate - DATETIMEVALUE( &apos;1996-01-01 15:00:00&apos; ), 1) ) ) 
) 
) 
), 
0 )/9
)</formula>
        <name>Days to close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GA_Commission</fullName>
        <field>GA_Commission__c</field>
        <formula>0.02</formula>
        <name>GA Commission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Sales_Opportunity_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Opportunity_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Sales Opportunity RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SHMMN_Flag_as_true</fullName>
        <field>SHMMN_Opportunity__c</field>
        <literalValue>1</literalValue>
        <name>Set SHMMN Flag as true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Bypass_Archive_ContactValidation</fullName>
        <field>By_Pass_Archive_Contact_Validation__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Bypass Archive ContactValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Update the record type to SHMMN Opportunity Read Only when Stage becomes Closed Lost.</description>
        <field>RecordTypeId</field>
        <lookupValue>SHMMN_Opportunity_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>auto_populate_Group_Renewal_Date</fullName>
        <field>Group_Renewal_Date__c</field>
        <formula>IF(
AND(Month(Plan_Effective_Date__c)=2,Day(Plan_Effective_Date__c)=29),
DATE(YEAR(Plan_Effective_Date__c) + 1, Month(Plan_Effective_Date__c),Day(Plan_Effective_Date__c)-1),
DATE(YEAR(Plan_Effective_Date__c) + 1, Month(Plan_Effective_Date__c),Day(Plan_Effective_Date__c))
)</formula>
        <name>auto populate Group Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>auto_populate_plan_end_date</fullName>
        <field>Plan_end_date__c</field>
        <formula>IF(MONTH(Plan_Effective_Date__c)=2 &amp;&amp; DAY(Plan_Effective_Date__c)=29, 
DATE(YEAR(Plan_Effective_Date__c)+1, 2, 27), 
DATE(YEAR(Plan_Effective_Date__c)+1, MONTH(Plan_Effective_Date__c), DAY(Plan_Effective_Date__c))-1 
)</formula>
        <name>auto populate plan end date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_GA_Commision</fullName>
        <field>GA_Commission__c</field>
        <formula>0.0002</formula>
        <name>update GA Commision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Close Date 7 Days Away</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <description>Email Account Owner when Opp Close Date is less than 7 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Account_Owner_when_Opp_Close_Date_is_less_than_7_Days_away</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Alert to Owner</fullName>
        <actions>
            <name>Opportunity_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalation for Not Accepted Shared SHMMN Opportunity</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Shared_with_SHP__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Accepted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This rule is used for the Shared SMMN Opportunity if not accepted by SHP Sales Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SHMMN_Shared_Opportunity_not_accepted_from_2_day</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Opportunity_Shared__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SHMMN_Shared_Opportunity_not_accepted_from_1_day</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Opportunity_Shared__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>GA Commission</fullName>
        <actions>
            <name>GA_Commission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(General_Agent_Applicable__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Users when SHP oppty is shared with SHMMN</fullName>
        <actions>
            <name>Notify_SHMMN_users_of_opportunities_shared_with_them</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Shared_with_SHMMN__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify about Renewed Opportunity</fullName>
        <actions>
            <name>Notify_Sales_Team_about_renewed_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Renewed_Opportunity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <description>This workflow is to notify sales team about renewed Opportunities</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify users of converted opportunities</fullName>
        <actions>
            <name>Notify</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Shared_with_SHP__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Closed Won</fullName>
        <actions>
            <name>Account_Updated_to_Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Employer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Created</fullName>
        <actions>
            <name>Account_Status_to_Proposal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Un Sold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Employer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pending AE,Pending Approval,Pending Broker,Pending Internal Review,Pending  U/W,Sales Released</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage is Closed Lost</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage is Closed Won</fullName>
        <actions>
            <name>Email_alert_when_Opportunity_stage_is_set_to_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>This rule will generate an email when the opportunity stage is set to Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Group Effective Date</fullName>
        <actions>
            <name>auto_populate_Group_Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Plan_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Group_Renewal_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Plan End date</fullName>
        <actions>
            <name>auto_populate_plan_end_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Plan_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Plan_end_date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RFP Due Date Remainder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RFP_Due_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>LAST 270 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Remainder_RFP_due_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.RFP_Due_Date__c</offsetFromField>
            <timeLength>270</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SHMMN Flag Set to True for SHMMN Opportunity</fullName>
        <actions>
            <name>Set_SHMMN_Flag_as_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Opportunity</value>
        </criteriaItems>
        <description>This if for setting SHMMN flag true if user created SHMMN opoortunity.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SHP Sales Opportunity RO</fullName>
        <actions>
            <name>SHP_Sales_Opportunity_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opp_Renewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time taken to close</fullName>
        <actions>
            <name>Days_to_close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck By Pass Archive Contact Validation Field</fullName>
        <actions>
            <name>Uncheck_Bypass_Archive_ContactValidation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.Name = &apos;SHP Sales Opportunity&apos;, By_Pass_Archive_Contact_Validation__c = true,ISCHANGED(By_Pass_Archive_Contact_Validation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update GA Commision</fullName>
        <actions>
            <name>update_GA_Commision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow Rule is used to Default GA Commission value as 2% for Small Groups or Individual</description>
        <formula>AND(OR(TEXT(Account.Employer_Type__c) = &apos;Small Group (1 - 50)&apos;,TEXT(Account.Employer_Type__c) = &apos;Small Mid-Market Group (1 - 50)&apos;,TEXT(Account.Employer_Type__c) = &apos;SmGrp&apos;, Account.RecordType.Name = &apos;SHP Sales Individual&apos;), RecordType.Name = &apos;SHP Sales Opportunity&apos;,ISBLANK( GA_Commission__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
