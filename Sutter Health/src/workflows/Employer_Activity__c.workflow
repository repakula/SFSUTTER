<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_to_assigned_user</fullName>
        <description>Email alert to assigned user</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/Employer_Activity_Email_Template_New</template>
    </alerts>
    <rules>
        <fullName>Email alert to Assigned User</fullName>
        <actions>
            <name>Email_alert_to_assigned_user</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to send email alert to user assigned to.</description>
        <formula>AND (  NOT(ISNULL(Assigned_To__c  )), ( OR(ISCHANGED(Assigned_To__c), ISNEW() ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
