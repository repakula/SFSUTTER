<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Sales_Manager_to_Remove</fullName>
        <description>Notify Sales Manager to Remove</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHMMN_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/No_Opportunity_on_Account_New</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Employer_Owner_with_No_Closed_won_Opportunity</fullName>
        <description>Send Email to Employer Owner with  No Closed won Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Email_Employer_Account_owner_if_there_is_no_Closed_One</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Status_Update</fullName>
        <description>Update Account Status to Contracted.</description>
        <field>Status__c</field>
        <literalValue>Contracted</literalValue>
        <name>Account Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Update_to_Un_Sold</fullName>
        <field>Status__c</field>
        <literalValue>Un Sold</literalValue>
        <name>Account Status Update to Un Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_external_field_update</fullName>
        <field>Account_External_ID1__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>Account external field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Date_after_7_Days</fullName>
        <field>Notify_Sales_Manager__c</field>
        <formula>Notify_Sales_Manager__c + 7</formula>
        <name>Set Opportunity Date after 7 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Date_after_Days</fullName>
        <field>SHP_Opportunity_Status_Date__c</field>
        <formula>SHP_Opportunity_Status_Date__c  +30</formula>
        <name>Set Opportunity Date after 30 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Share_with_Salesmanager</fullName>
        <field>Sent_for_Removed__c</field>
        <literalValue>1</literalValue>
        <name>Share with Salesmanager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Update_Account_Record_type_SHP_Sales_Bro</fullName>
        <description>This is to update account record type when lead conversion for SHP Sales Broker</description>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Broker</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account Record type SHP Sales Bro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Record_type_SHP_Sales_Emp</fullName>
        <description>This is to update account record type when lead conversion for SHP Sales Employer</description>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Employer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account Record type SHP Sales Emp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Broker_Record_Type</fullName>
        <description>This workflow action will flip the record type on the Account</description>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Broker_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Broker Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Broker_firm_HCC_Id</fullName>
        <description>Broker filed update</description>
        <field>Broker_Firm_HCC_ID__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>Update Broker firm HCC Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Employer_Account_External_ID1</fullName>
        <field>Account_External_ID1__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>Update Employer Account External ID1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Employer_HCC_ID</fullName>
        <description>Update Employer HCC ID using Group ID</description>
        <field>Employer_HCC_ID__c</field>
        <formula>SHP_Group_ID__c</formula>
        <name>Update Employer HCC ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Employer_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Employer_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Employer Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Healthrules_HCC_ID</fullName>
        <description>updates hcc id on Broker type of account</description>
        <field>HealthRules_ID__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>Update Healthrules HCC ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_account_record_type</fullName>
        <description>Update account record type to SHP Sales Individual when lead converted</description>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update account record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Update to Un Sold</fullName>
        <actions>
            <name>Account_Status_Update_to_Un_Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND((Count_of_Opportunities_Created__c &gt; 0), ( RecordType.Name = &apos;SHMMN Employer&apos;),  (Count_of_Opportunities_Created__c  =  Opportunities_lost__c)), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Broker HealthRules ID Populated</fullName>
        <actions>
            <name>Update_Broker_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.HealthRules_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker</value>
        </criteriaItems>
        <description>This rule will flip the SHP Sales Broker Account Type to a Read Only record type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contracted Account</fullName>
        <actions>
            <name>Account_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update status of strategic marketing employer account as Contracted.</description>
        <formula>IF( AND((RecordType.Name = &apos;SHMMN Employer&apos;),   ISPICKVAL(Status__c,&apos;Sold&apos;),  NOT(ISPICKVAL( Account_Tier__c,&apos;&apos; )), NOT(ISBLANK(   Employer_First_Renewal_Date__c   )), NOT(ISBLANK(  Employer_Next_Renewal_Date__c  )),(  Agreement_Signed__c = true  ))  , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Employer Account with No closed one Opportunity</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Employer,SHP Sales Employer Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.No_of_closed_won_Opp__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email_to_Employer_Owner_with_No_Closed_won_Opportunity</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_Opportunity_Date_after_Days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.SHP_Opportunity_Status_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Employer HealthRules ID Populated</fullName>
        <actions>
            <name>Update_Employer_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.HealthRules_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Employer</value>
        </criteriaItems>
        <description>This rule will flip the SHP Sales Employer Account Type to a Read Only record type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Notify Sales Manager to remove</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Employer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Un Sold</value>
        </criteriaItems>
        <description>Workflow rule to notify sales manager to update inactive account status to Removed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_Sales_Manager_to_Remove</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_Opportunity_Date_after_7_Days</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Share_with_Salesmanager</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Notify_Sales_Manager__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SHP Broker Account External ID update</fullName>
        <actions>
            <name>Account_external_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Broker_firm_HCC_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Healthrules_HCC_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Account_External_ID1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>updating account external field on Broker Account</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Employer Account External ID update</fullName>
        <actions>
            <name>Update_Employer_Account_External_ID1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Employer_HCC_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updating account external field for employer account</description>
        <formula>RecordType.Name = &apos;SHP Sales Employer&apos;||RecordType.Name = &apos;SHP Sales Employer Read Only&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck By Pass Archive Contact Validation Field</fullName>
        <actions>
            <name>Uncheck_Bypass_Archive_ContactValidation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(RecordType.Name = &apos;SHP Sales Employer&apos;,RecordType.Name = &apos;SHP Sales Employer Read Only&apos;,RecordType.Name = &apos;SHP Sales Broker&apos;,RecordType.Name = &apos;SHP Sales Broker Read Only&apos;), By_Pass_Archive_Contact_Validation__c = true,ISCHANGED(By_Pass_Archive_Contact_Validation__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record type SHP Sales Broker</fullName>
        <actions>
            <name>Update_Account_Record_type_SHP_Sales_Bro</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Lead_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>SHP Sales Broker</value>
        </criteriaItems>
        <description>Update Account Record type on Lead Conversion for SHP Sales Broker</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record type SHP Sales Employer</fullName>
        <actions>
            <name>Update_Account_Record_type_SHP_Sales_Emp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Lead_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>SHP Sales Employer</value>
        </criteriaItems>
        <description>Update Account Record type on Lead Conversion for SHP Sales Employer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record type on Lead convertion</fullName>
        <actions>
            <name>Update_account_record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Lead_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>SHP Sales Individual</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
