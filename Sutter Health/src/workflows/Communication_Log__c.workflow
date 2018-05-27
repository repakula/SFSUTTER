<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>AQRS%3A Task Creation on Communication Log</fullName>
        <actions>
            <name>Communication_Log_Reminder</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Communication_Log__c.Need_Reminder__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Communication_Log__c.Reminder_Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Followup Reminder</fullName>
        <actions>
            <name>Please_Followup_Patient</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>NOT( ISBLANK( Next_contact_Date__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Communication_Log_Reminder</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Communication_Log__c.Reminder_Activity_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Communication Log Reminder</subject>
    </tasks>
    <tasks>
        <fullName>Please_Followup_Patient</fullName>
        <assignedTo>lakshmi.repakula@itcinfotech.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please followup the Patient</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Communication_Log__c.Next_contact_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please Followup Patient</subject>
    </tasks>
</Workflow>
