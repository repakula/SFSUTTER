<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SendCommentNotificationEmail</fullName>
        <description>SendCommentNotificationEmail</description>
        <protected>false</protected>
        <recipients>
            <field>NotificationEmailTo__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Manager_Feedback_CommentNotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateNotificationEmailToField</fullName>
        <field>NotificationEmailTo__c</field>
        <formula>Managers_Feedback__r.WorkEmail__c</formula>
        <name>UpdateNotificationEmailToField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CommentEmailNotficationUpdate</fullName>
        <actions>
            <name>UpdateNotificationEmailToField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISNULL( Comments__c )   ||    LEN( TRIM( Comments__c ) )   &lt;=  0)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Manager Feedback Comment Notification</fullName>
        <actions>
            <name>SendCommentNotificationEmail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>NOT(  ISNULL( Comments__c )   ||    LEN( TRIM( Comments__c ))    &lt;=  0 )  &amp;&amp;   NOT( ISNULL( NotificationEmailTo__c ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
