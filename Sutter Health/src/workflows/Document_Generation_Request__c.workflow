<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DGR_is_Not_Approved</fullName>
        <description>DGR is Not Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_BPA_QA_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/DGR_is_Not_Approved</template>
    </alerts>
    <alerts>
        <fullName>DocGenRequest_QA_Rejected</fullName>
        <description>DocGenRequest QA Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_QA_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/DocGenRequest_QA_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Doc_Gen_Request_Approved_Notification</fullName>
        <description>Doc Gen Request Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_BPA_QA_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Doc_Gen_Request_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Expedition_on_Document_Request_Rejected_Email_Template</fullName>
        <description>Expedition on Document Request Rejected Email Template</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Expedition_on_Document_Request_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Sales_Team_on_Expedition_Approval</fullName>
        <description>Notify Sales Team on Expedition Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Notify_Sales_Team_on_Expedition_Approval</template>
    </alerts>
    <alerts>
        <fullName>Notify_Sales_on_Doc_Gen_Req_Cancellation</fullName>
        <description>Notify Sales on Doc Gen Req Cancellation</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_BPA_QA_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Document_Generation_Request_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Request_Sales_for_Final_Approval_of_Document_Generation</fullName>
        <description>Request Sales for Final Approval of Document Generation</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_BPA_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Document_Generation_Request_QA_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Doc_Gen_Cancelled</fullName>
        <field>OwnerId</field>
        <lookupValue>Canceled_Doc_Gen_Requests_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Doc.Gen Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Set_to_BPA_Approvers_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_BPA_Approvers_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Set to BPA Approvers Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Set_to_BPA_QA_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Custom_Benefit_Plan_QA_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Set to BPA QA Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Set_to_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Set to Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_set_to_Benefit_Plan_Admin_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Benefit_Plan_Admin_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner set to Benefit Plan Admin Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Status_as_Rejected</fullName>
        <field>Request_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Request Status as Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Status_as_Waiting_for_BPA_QA</fullName>
        <field>Request_Status__c</field>
        <formula>&quot;Waiting for BPA QA&quot;</formula>
        <name>Request Status as Waiting for BPA QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_status_as_Approved</fullName>
        <field>Request_Status__c</field>
        <formula>&quot;Approved by Sales&quot;</formula>
        <name>Request status as Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_status_as_Approved_by_BPA_QA</fullName>
        <field>Request_Status__c</field>
        <formula>&quot;Approved by BPA QA&quot;</formula>
        <name>Request status as Approved by BPA QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_status_as_Rejected_by_BPA_QA</fullName>
        <field>Request_Status__c</field>
        <formula>&quot;Rejected by BPA QA&quot;</formula>
        <name>Request status as Rejected by BPA QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revert_back_Expedition_req_Checkbox</fullName>
        <field>Requested_Expedition__c</field>
        <literalValue>0</literalValue>
        <name>Revert back Expedition req Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_as_Sales_Executive_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Custom_Plan_Executive_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner as Sales Executive Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Expedite_as_True</fullName>
        <field>Expedite__c</field>
        <literalValue>1</literalValue>
        <name>Update Expedite as True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Canceled Doc%2E Gen%2E Requests Queue</fullName>
        <actions>
            <name>Doc_Gen_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Document_Generation_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request Cancelled</value>
        </criteriaItems>
        <description>When the status is of DGR is changed to Request Cancelled, it needs to get assigned to the Cancelled queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Sales on Doc Gen Req Cancellation</fullName>
        <actions>
            <name>Notify_Sales_on_Doc_Gen_Req_Cancellation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Document_Generation_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
