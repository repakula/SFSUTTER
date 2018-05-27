<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SHP_Correspondence_Email</fullName>
        <description>SHP Correspondence Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Correspondence_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>coxt3@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Correspondence_Email</template>
    </alerts>
    <rules>
        <fullName>Correspondence Email Alert</fullName>
        <actions>
            <name>SHP_Correspondence_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Correspondence__c.Member_Type__c</field>
            <operation>equals</operation>
            <value>Member,Broker,Provider,Employer</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
