<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approved_lead_email_notification</fullName>
        <description>Approved lead email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/Approved_Lead_New</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_notify_sales_manager_queue_of_qualified_lead</fullName>
        <description>Email alert to notify sales manager queue of qualified lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHMMN_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/Qualified_Lead_New</template>
    </alerts>
    <alerts>
        <fullName>Rejected_lead_email_notification</fullName>
        <description>Rejected lead email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Strategic_Marketing_Templates/Rejected_Lead_New</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Lead_Assigned</fullName>
        <field>Lead_Assigned__c</field>
        <formula>OwnerId</formula>
        <name>Update Lead Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_skip_validation_as_false</fullName>
        <description>Update skip validation as false</description>
        <field>Skip_Validation__c</field>
        <literalValue>0</literalValue>
        <name>Update skip validation as false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approved lead notification</fullName>
        <actions>
            <name>Approved_lead_email_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Lead</value>
        </criteriaItems>
        <description>Workflow to send email notification to owner of lead when lead is approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status updated Qualified</fullName>
        <actions>
            <name>Email_alert_to_notify_sales_manager_queue_of_qualified_lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rejected lead notification</fullName>
        <actions>
            <name>Rejected_lead_email_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHMMN Lead</value>
        </criteriaItems>
        <description>Workflow to send email notification to owner of lead when lead is rejected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Skip validation lead owner rule</fullName>
        <actions>
            <name>Update_skip_validation_as_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Skip_Validation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Candidate</value>
        </criteriaItems>
        <description>Skip validation lead owner rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
