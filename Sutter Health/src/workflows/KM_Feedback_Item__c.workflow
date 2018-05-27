<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_KM_Feedback_Owner</fullName>
        <description>Email Alert to KM Feedback Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/KM_Feedback_Ownership</template>
    </alerts>
    <alerts>
        <fullName>KM_Feedback_Thank_you_mail</fullName>
        <description>KM Feedback Thank you mail</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/KM_Feedback_Thank_You_Mail_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Projected_Due_Date</fullName>
        <field>Due_Date__c</field>
        <formula>DATEVALUE(CreatedDate) + 14</formula>
        <name>Update Projected Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Alert to KM Feedback Owner</fullName>
        <actions>
            <name>Email_Alert_to_KM_Feedback_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(BEGINS(OwnerId , &apos;00G&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>KM Feedback</fullName>
        <active>false</active>
        <criteriaItems>
            <field>KM_Feedback_Item__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed - Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KM Feedback Item Mail on Complete</fullName>
        <actions>
            <name>KM_Feedback_Thank_you_mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>KM_Feedback_Item__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed - Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update KM Feedback Projected Due Date</fullName>
        <actions>
            <name>Update_Projected_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Projected Due date as per Feedback Reason</description>
        <formula>AND(  OR( ISCHANGED( Feedback_Reason__c ), ISNEW()  ), NOT(ISNULL(TEXT(Feedback_Reason__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
