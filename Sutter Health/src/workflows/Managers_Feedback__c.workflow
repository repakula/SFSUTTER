<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ManagerFeedbackL2OwnerEmailAlert</fullName>
        <description>Email to ManagerFeedback L2Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Email_to_L1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Manager_Feedback_To_L2_Owner</template>
    </alerts>
    <alerts>
        <fullName>ManagersFeedbackChangeIdentifiedAlert</fullName>
        <description>Change Identified resolution email alert for Managers Feedback creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ManagerFeedbackClosed_ChangeIdentified</template>
    </alerts>
    <alerts>
        <fullName>ManagersFeedbackChangeImplementedAlert</fullName>
        <description>Change Implemented resolution email alert for Managers Feedback creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ManagerFeedbackClosed_ChangeImplemented</template>
    </alerts>
    <alerts>
        <fullName>ManagersFeedbackClosedThankYouAlert</fullName>
        <description>Send a thank you resolution email alert for Managers Feedback creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ManagerFeedbackClosed_SendThankYou</template>
    </alerts>
    <fieldUpdates>
        <fullName>AssignFeedbackToQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>Manager_Feedback</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssignFeedbackToQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Date_Status_Closed</fullName>
        <field>Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Closed Date Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_feedback_Recordtype</fullName>
        <description>Set Record type to Manager Feedback RO</description>
        <field>RecordTypeId</field>
        <lookupValue>ManagerFeedback_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Manager feedback Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecTypeUpdate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ManagerFeedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecTypeUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Closed Date Status Closed</fullName>
        <actions>
            <name>Closed_Date_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Closed Date Status Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Manager Feedback RO</fullName>
        <actions>
            <name>Manager_feedback_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Managers_Feedback__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ManagerFeedback,ManagerFeedback RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Set Manager Feedback RO recordtype</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ManagerFeedbackL2Owner</fullName>
        <actions>
            <name>ManagerFeedbackL2OwnerEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>Manager Feedback</value>
        </criteriaItems>
        <description>Trigger a  mail to L2 Owner</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ManagerFeedbackRecordInsert</fullName>
        <actions>
            <name>AssignFeedbackToQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Assign record to Queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ManagerFeedbackRule</fullName>
        <actions>
            <name>RecTypeUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Status__c, &apos;closed&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ManagersFeedbackChangeIdentified</fullName>
        <actions>
            <name>ManagersFeedbackChangeIdentifiedAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Send_Resolution_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Resolution__c</field>
            <operation>equals</operation>
            <value>Change Identified</value>
        </criteriaItems>
        <description>If status is closed and resolution is Change Identified then send an email .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ManagersFeedbackChangeImplemented</fullName>
        <actions>
            <name>ManagersFeedbackChangeImplementedAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Send_Resolution_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Resolution__c</field>
            <operation>equals</operation>
            <value>Change Implemented</value>
        </criteriaItems>
        <description>If status is closed and resolution is Change Implemented then send an email .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ManagersFeedbackSendThankYou</fullName>
        <actions>
            <name>ManagersFeedbackClosedThankYouAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Managers_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Send_Resolution_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Managers_Feedback__c.Resolution__c</field>
            <operation>equals</operation>
            <value>Send a Thank You</value>
        </criteriaItems>
        <description>If status is closed and resolution is Send a Thank You then send an email .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
