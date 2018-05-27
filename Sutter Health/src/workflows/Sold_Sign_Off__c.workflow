<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Sales_on_SSO_Creation</fullName>
        <description>Notify Sales on SSO Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Notify_Sales_on_SSO_Creation</template>
    </alerts>
    <alerts>
        <fullName>Request_for_Sold_Sign_Off_submitted_is_not_Approved</fullName>
        <description>Request for Sold Sign Off submitted is not Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Request_for_Sold_Sign_Off_submitted_is_not_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>HighRoads_SSO_FU01_UpdateFormSubmitter</fullName>
        <field>Form_Submitter_Name__c</field>
        <formula>$User.FirstName +&apos; &apos;+ $User.LastName</formula>
        <name>HighRoads_SSO_FU01_UpdateFormSubmitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_is_set_to_Underwriting_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Underwriter_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner is set to &quot;Underwriting Queue&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_set_to_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner set to Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SSO_Owner_Field</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Void_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SSO Owner Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SSO_stage_to_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Approved by Underwriting</literalValue>
        <name>Update SSO stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SSO_stage_to_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected by Underwriting</literalValue>
        <name>Update SSO stage to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SSO_stage_to_Submitted</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted to Underwriting</literalValue>
        <name>Update SSO stage to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>HighRoads_SSO_WF01_UpdateFormSubmitterName</fullName>
        <actions>
            <name>HighRoads_SSO_FU01_UpdateFormSubmitter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sold_Sign_Off__c.Stage__c</field>
            <operation>equals</operation>
            <value>Submitted to Underwriting</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Sales on SSO Creation</fullName>
        <actions>
            <name>Notify_Sales_on_SSO_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sold_Sign_Off__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SSO Void Queue</fullName>
        <actions>
            <name>SSO_Owner_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sold_Sign_Off__c.Rejection_Reason__c</field>
            <operation>equals</operation>
            <value>Void</value>
        </criteriaItems>
        <description>Workflow to update the owner field to SHP void queue, when rejection reason is VOID</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
