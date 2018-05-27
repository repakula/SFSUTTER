<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RFP_RFR_has_not_been_Approved</fullName>
        <description>RFP/RFR has not been Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/RFP_RFR_has_not_been_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Owner_set_to_Underwriter_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Underwriter_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner set to Underwriter Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Owner_field</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Void_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>RFP Owner field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Stage_change_on_Rejection</fullName>
        <description>RFP Stage is changed to &quot;Rejected by Underwriting&quot;</description>
        <field>Stage__c</field>
        <literalValue>Rejected by Underwriting</literalValue>
        <name>RFP Stage change on Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFP_Stage_change_on_approval</fullName>
        <description>RFP Stage is changed to &quot;approved by underwriting&quot;</description>
        <field>Stage__c</field>
        <literalValue>Approved by Underwriting</literalValue>
        <name>RFP Stage change on approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Field_Update</fullName>
        <field>Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>Stage Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_of_RFP_on_Submission</fullName>
        <description>Update Status of RFP from &quot;Draft&quot; to &quot;Submitted to underwriting&quot;</description>
        <field>Stage__c</field>
        <literalValue>Submitted to Underwriting</literalValue>
        <name>Update Stage of RFP on Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>assign_to_sales_queue_on_approval</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>assign to sales queue on approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>assign_to_sales_queue_upon_rejection</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>assign to sales queue upon rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RFP Void Queue</fullName>
        <actions>
            <name>RFP_Owner_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incumbent_Carrier__c.Reject_Reason__c</field>
            <operation>equals</operation>
            <value>Void</value>
        </criteriaItems>
        <description>Workflow to update the owner field to SHP void queue, when rejection reason is VOID</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stage Update</fullName>
        <actions>
            <name>Stage_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incumbent_Carrier__c.Stage__c</field>
            <operation>notEqual</operation>
            <value>Draft,Submitted to Underwriting,Approved by Underwriting,Rejected by Underwriting</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
