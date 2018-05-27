<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RFI_Completion_Date</fullName>
        <field>RFI_Completion_Date__c</field>
        <formula>Date_Information_Received__c</formula>
        <name>RFI Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Service_Request__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RFI</fullName>
        <field>RFI_Request_Date__c</field>
        <formula>Date_Information_Requested__c</formula>
        <name>Update RFI Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Service_Request__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Provider Dispute %E2%80%93 RFI 1</fullName>
        <actions>
            <name>Update_RFI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Number_of_RFIs__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Even_RFIs__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Provider Dispute %E2%80%93 RFI 2</fullName>
        <actions>
            <name>Update_RFI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Even_RFIs__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Provider Dispute %E2%80%93 RFI Completion Date</fullName>
        <actions>
            <name>RFI_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
