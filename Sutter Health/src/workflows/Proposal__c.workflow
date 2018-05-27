<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Underwriting_on_Quote_Creation</fullName>
        <description>Notify Underwriting on Quote Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Notify_Underwriting_on_Quote_Creation</template>
    </alerts>
    <alerts>
        <fullName>Quote_approved_Notification</fullName>
        <description>Quote approved Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Quote_approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Quote_s_is_not_Approved</fullName>
        <description>Quote(s) is not Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Quote_s_is_not_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Owner_is_set_to_Sales_Queue</fullName>
        <description>Owner is set to &quot;Sales Queue&quot; after submitting record</description>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner is set to &quot;Sales Queue&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_set_to_Underwriter_Queue</fullName>
        <description>Owner field is set to &quot;Underwriter Queue&quot;</description>
        <field>OwnerId</field>
        <lookupValue>SHP_Underwriter_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner set to Underwriter Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_stage_to_Approved</fullName>
        <description>Update stage to &quot;Approved by Sales&quot; when Quote is approved</description>
        <field>Stage__c</field>
        <literalValue>Approved by Sales</literalValue>
        <name>Update Quote stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_stage_to_Rejected</fullName>
        <description>Update Stage of Quote to &quot;Rejected by Sales&quot; when SHP Quote is Rejected</description>
        <field>Stage__c</field>
        <literalValue>Rejected by Sales</literalValue>
        <name>Update Quote stage to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_of_Quote_on_Submission</fullName>
        <description>Update stage of Quote to &quot;Submitted to Sales&quot;</description>
        <field>Stage__c</field>
        <literalValue>Submitted to Sales</literalValue>
        <name>Update stage of Quote on Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Underwriting on Quote Creation</fullName>
        <actions>
            <name>Notify_Underwriting_on_Quote_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proposal__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
