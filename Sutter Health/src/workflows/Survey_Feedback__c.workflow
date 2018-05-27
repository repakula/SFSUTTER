<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Survey_Feedback_Email_Alert</fullName>
        <description>Survey Feedback Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address_To_Send_Mail1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_To_Send_Mail2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/Survey_Feedback_To_Owner</template>
    </alerts>
    <alerts>
        <fullName>Survey_Feedback_Email_Alert_To_Leads</fullName>
        <description>Survey Feedback Email Alert To Leads</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address_To_Send_Mail1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Address_To_Send_Mail2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>babag@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>khotpaj@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salgadj@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/Survey_Feedback_To_Owner</template>
    </alerts>
    <alerts>
        <fullName>Survey_Feedback_Email_Alert_To_Owner</fullName>
        <description>Survey Feedback Email Alert To Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/Survey_Feedback_To_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>Survey_feedback_Employee_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Employee_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Survey feedback Employee RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_feedback_Vendor_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Vendor_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Survey feedback Vendor RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Survey Feedback Email</fullName>
        <actions>
            <name>Survey_Feedback_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(OR(RecordType.Name =&apos;Employee&apos;,RecordType.Name =&apos;Vendor&apos;),OwnerId != PRIORVALUE(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Survey Feedback Email To Leads</fullName>
        <actions>
            <name>Survey_Feedback_Email_Alert_To_Leads</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(RecordType.Name =&apos;Employee&apos;,RecordType.Name =&apos;Vendor&apos;),OwnerId != PRIORVALUE(OwnerId),ISCHANGED(Email_Address_To_Send_Mail1__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Survey Feedback Email To Owner</fullName>
        <actions>
            <name>Survey_Feedback_Email_Alert_To_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(RecordType.Name =&apos;Employee&apos;,RecordType.Name =&apos;Vendor&apos;),OwnerId != PRIORVALUE(OwnerId),NOT(ISCHANGED(Email_Address_To_Send_Mail1__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Survey feedback Employee RO</fullName>
        <actions>
            <name>Survey_feedback_Employee_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Feedback__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey feedback Vendor RO</fullName>
        <actions>
            <name>Survey_feedback_Vendor_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Feedback__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
