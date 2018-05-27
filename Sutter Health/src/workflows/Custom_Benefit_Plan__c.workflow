<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Custom_Benefit_Plan_Not_Soft_Approved</fullName>
        <description>Custom Benefit Plan Not Soft Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_Not_Soft_Approved</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_Rejected_by_Executive_Team</fullName>
        <description>Custom Benefit Plan Rejected by Executive Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_Rejected_by_Executive_Team</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_Soft_Approval_is_Pending</fullName>
        <description>Custom Benefit Plan Soft Approval is Pending</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_Soft_Approval_is_Pending</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_is_DMHC_Approved</fullName>
        <description>Custom Benefit Plan is DMHC Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Underwriter</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_is_DMHC_Approved</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_is_Final_Approved</fullName>
        <description>Custom Benefit Plan is Final Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_is_Final_Approved</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_is_Not_DMHC_Approved</fullName>
        <description>Custom Benefit Plan is Not DMHC Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_is_Not_DMHC_Approved</template>
    </alerts>
    <alerts>
        <fullName>Custom_Benefit_Plan_is_Pending_DMHC_Approval</fullName>
        <description>Custom Benefit Plan is Pending DMHC Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_is_Pending_DMHC_Approval</template>
    </alerts>
    <alerts>
        <fullName>Notify_Sales_on_Custom_Benefit_Plan_Soft_Approval</fullName>
        <description>Notify Sales on Custom Benefit Plan Soft Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_Soft_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Final_Approval_Email_Notification</fullName>
        <description>Send Final Approval Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Custom_Plan_Final_Approver_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/Custom_Benefit_Plan_Sold</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Status_Submitted_to_Exec_Team</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Submitted to Executive Group</literalValue>
        <name>Change Status - Submitted to Exec Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Facility_Fee_update</fullName>
        <field>Facility_fee_e_g_hospital_room__c</field>
        <formula>Benefit_Grid__r.C08_Facility_fee_e_g_hospital_room__c</formula>
        <name>Facility Fee update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approve_Queues</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_BPA_Custom_Plan_Final_Approver_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Final Approve Queues</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_To_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Sales_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner To Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_set_to_Executive_Team_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Custom_Plan_Executive_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner set to Executive Team Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Custom_Plan_Soft_Approver_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_BPA_Custom_Plan_Soft_Approver_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to Custom Plan Soft Approver Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Final_Approver_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Custom_Plan_Final_Approver_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to Final Approver Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Soft_Approval_Queue</fullName>
        <description>Set Owner to Soft Approval Queue</description>
        <field>OwnerId</field>
        <lookupValue>SHP_BPA_Custom_Plan_Soft_Approver_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Soft Approval Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Soft_Approve_Queues</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_BPA_Custom_Plan_Soft_Approver_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Soft Approve Queues</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tier_1_Field_Update</fullName>
        <field>RX_Tier_1__c</field>
        <formula>Benefit_Grid__r.C11_Retail_Tier_1__c</formula>
        <name>Tier 1 Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tier_2_Field_Update</fullName>
        <field>RX_Tier_2__c</field>
        <formula>Benefit_Grid__r.C11_Retail_Tier_2__c</formula>
        <name>Tier 2 Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tier_3_Field_update</fullName>
        <field>RX_Tier_3__c</field>
        <formula>Benefit_Grid__r.C11_Retail_Tier_3__c</formula>
        <name>Tier 3 Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tier_4_Field_update</fullName>
        <field>RX_Tier_4__c</field>
        <formula>Benefit_Grid__r.C11_Retail_Tier_4__c</formula>
        <name>Tier 4 Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Final_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Pending_with_BPA_Team</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Pending with BPA Team</literalValue>
        <name>Update Status to Pending with BPA Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected_by_BPA_Team</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Rejected by BPA Team</literalValue>
        <name>Update Status to Rejected by BPA Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected_by_Exec_Group</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Rejected by Executive Group</literalValue>
        <name>Update Status to Rejected by Exec Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Soft_Approved</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Soft Approved</literalValue>
        <name>Update Status to Soft Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Custom Benefit Plan Soft Approval is Pending</fullName>
        <actions>
            <name>Custom_Benefit_Plan_Soft_Approval_is_Pending</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.BPA_Internal_Status__c</field>
            <operation>equals</operation>
            <value>Pending Compliance Review,Pending Underwriting Review,Pending DMHC Review,Pending BPA Review,Pending Legal Review</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom Benefit Plan is DMHC Approved</fullName>
        <actions>
            <name>Custom_Benefit_Plan_is_DMHC_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.DMHC_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom Benefit Plan is Final Approved</fullName>
        <actions>
            <name>Custom_Benefit_Plan_is_Final_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.Plan_Status__c</field>
            <operation>equals</operation>
            <value>Available for Sale - Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom Benefit Plan is Not DMHC Approved</fullName>
        <actions>
            <name>Custom_Benefit_Plan_is_Not_DMHC_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.DMHC_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom Benefit Plan is Pending DMHC Approval</fullName>
        <actions>
            <name>Custom_Benefit_Plan_is_Pending_DMHC_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.BPA_Internal_Status__c</field>
            <operation>equals</operation>
            <value>Pending DMHC Review</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Final Approve Queues</fullName>
        <actions>
            <name>Final_Approve_Queues</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.Plan_Status__c</field>
            <operation>equals</operation>
            <value>Available for Sale - Approved</value>
        </criteriaItems>
        <description>When the plan status is Approved then owner field gets updated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Soft Approve Queues</fullName>
        <actions>
            <name>Soft_Approve_Queues</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.Plan_Status__c</field>
            <operation>equals</operation>
            <value>Soft Approved</value>
        </criteriaItems>
        <description>When the plan status is Soft Approved then owner field gets updated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tier field updates</fullName>
        <actions>
            <name>Facility_Fee_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tier_1_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tier_2_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tier_3_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tier_4_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Custom_Benefit_Plan__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Plan_Status__c),ISPICKVAL(Plan_Status__c,&apos;Available for Sale - Approved&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
