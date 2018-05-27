<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approved_by_UM</fullName>
        <description>Approved by  UM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Approved_by_CMO</template>
    </alerts>
    <alerts>
        <fullName>PQI_Approved_By_CMO1</fullName>
        <description>PQI Approved By CMO1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Approved_by_CMO</template>
    </alerts>
    <alerts>
        <fullName>PQI_Rejected</fullName>
        <description>PQI Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Rejected</template>
    </alerts>
    <alerts>
        <fullName>PQI_Rejected_CMO</fullName>
        <description>PQI Rejected CMO</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Rejected</template>
    </alerts>
    <alerts>
        <fullName>PQI_Rejected_by_CMO</fullName>
        <description>PQI Rejected by CMO</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Rejected_CMO</template>
    </alerts>
    <alerts>
        <fullName>PQI_approved_by_UM_and_assign_to_quality</fullName>
        <description>PQI approved by UM and assign to quality</description>
        <protected>false</protected>
        <recipients>
            <recipient>Quality_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Approved_by_CMO</template>
    </alerts>
    <alerts>
        <fullName>PRC_Rejected</fullName>
        <description>PRC Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PQI_Rejected_By_PRC</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_Quality</fullName>
        <field>OwnerId</field>
        <lookupValue>Quality</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Quality</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_PRC</fullName>
        <field>PQI_Status__c</field>
        <literalValue>PRC</literalValue>
        <name>Change status to PRC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MD_Approved_Status</fullName>
        <field>PQI_Status__c</field>
        <literalValue>MD Approved</literalValue>
        <name>MD Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MD_Rejected</fullName>
        <field>PQI_Status__c</field>
        <literalValue>MD Rejected</literalValue>
        <name>MD Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_CMO</fullName>
        <field>OwnerId</field>
        <lookupValue>CMO</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to CMO</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_UM</fullName>
        <field>OwnerId</field>
        <lookupValue>UM_Reviewers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to UM</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PRC_approved</fullName>
        <field>PQI_Status__c</field>
        <literalValue>PRC Approved</literalValue>
        <name>PRC approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_CMO</fullName>
        <field>PQI_Status__c</field>
        <literalValue>MD Review</literalValue>
        <name>Status to CMO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_UM</fullName>
        <field>PQI_Status__c</field>
        <literalValue>UM Review</literalValue>
        <name>Status to UM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Rejected</fullName>
        <field>PQI_Status__c</field>
        <literalValue>UM Rejected</literalValue>
        <name>UM Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PQI Sent Email to Quality for ByPass CMO</fullName>
        <actions>
            <name>PQI_approved_by_UM_and_assign_to_quality</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL( PQI_Status__c , &apos;UM Approved&apos;) , ISCHANGED(PQI_Status__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
