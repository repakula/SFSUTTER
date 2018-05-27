<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Sales_Inquiry_Notification</fullName>
        <description>Send a notification to SHP Sales team regarding a new sales inquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/New_Sales_Inquiry</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_Sales_Inquiry_to_SHP_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Sales Inquiry to SHP Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Close_Date_Equal_Today</fullName>
        <field>Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Close Date Equal Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Sales Inquiry to SHP Sales Queue</fullName>
        <actions>
            <name>New_Sales_Inquiry_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Sales_Inquiry_to_SHP_Sales_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sales_Inquiry__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Sales_Inquiry__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Assign Sales inquiry to SHP Sales queue and generate email to queue members IF Status of Sales Inquiry = New</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Close Date When SI Status is Closed</fullName>
        <actions>
            <name>Set_Close_Date_Equal_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sales_Inquiry__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Set Close Date When SI Status is Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
