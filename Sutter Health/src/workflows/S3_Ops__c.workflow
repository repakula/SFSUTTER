<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>S3_SSLT_Change_Request_Result</fullName>
        <description>S3 SSLT Change Request Result</description>
        <protected>false</protected>
        <recipients>
            <recipient>hernanf3@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/DMC_Service_Request_Status_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>AB_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>baumgaal@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>AB Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Request_Update</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Request Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Process_Step</fullName>
        <field>Process_Step__c</field>
        <name>Clear Process Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Metric_Assignment_NS</fullName>
        <field>OwnerId</field>
        <lookupValue>maciasa2@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Metric Assignment NS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Metric_Specialist_Assignment_KM</fullName>
        <field>OwnerId</field>
        <lookupValue>metcalk@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Metric Specialist Assignment-KM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Update_CAG</fullName>
        <field>Process_Step__c</field>
        <literalValue>CAG Approval Pending</literalValue>
        <name>Process Update CAG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Update_SSLT</fullName>
        <field>Process_Step__c</field>
        <literalValue>SSLT Approval Pending</literalValue>
        <name>Process Update SSLT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Update_Steer</fullName>
        <field>Process_Step__c</field>
        <literalValue>Steering Committee Approval Pending</literalValue>
        <name>Process Update Steer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval Process</literalValue>
        <name>Rejected Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Field_Update_CC</fullName>
        <field>Status__c</field>
        <literalValue>Rejected: Additional Information Needed</literalValue>
        <name>Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Field_Update_Final</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejection Field Update Final</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Retracted_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Retracted</literalValue>
        <name>Retracted Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Ops_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>S3_Ops_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>S3 Ops Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Ops_Review</fullName>
        <field>Process_Step__c</field>
        <literalValue>Operational Team Review</literalValue>
        <name>S3 Ops Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Pending_Approval_Process</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval Process</literalValue>
        <name>S3 Pending Approval Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SMP1_Metrics</fullName>
        <field>OwnerId</field>
        <lookupValue>baumgaal@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SPM1 Metrics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SPM2_Metrics</fullName>
        <field>OwnerId</field>
        <lookupValue>maciasa2@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SPM2 Metrics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SPM3_Metrics</fullName>
        <field>OwnerId</field>
        <lookupValue>metcalk@sutterhealth.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SPM3 Metrics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_CAG_Pending</fullName>
        <field>Status__c</field>
        <literalValue>CAG Approval Pending</literalValue>
        <name>Status Update CAG Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_CF_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Cross-Functional Approval Pending</literalValue>
        <name>Status Update CF Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_SSLT_Pending</fullName>
        <field>Status__c</field>
        <literalValue>SSLT Approval Pending</literalValue>
        <name>Status Update SSLT Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Steer_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Steering Committee Approval Pending</literalValue>
        <name>Status Update Steer Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Metric Specialist Assignment-AB</fullName>
        <actions>
            <name>AB_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3 or 4 or 5)</booleanFilter>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Contact Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Document Management Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Human Resources</value>
        </criteriaItems>
        <description>Amanda&apos;s Functions</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Metric Specialist Assignment-KB</fullName>
        <actions>
            <name>Metric_Specialist_Assignment_KM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3)</booleanFilter>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Supply Chain</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Biomedical Technology</value>
        </criteriaItems>
        <description>Ken&apos;s Function Assignment for S3 Metrics</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Metric Specialist Assignment-NS</fullName>
        <actions>
            <name>Metric_Assignment_NS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3)</booleanFilter>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Revenue Cycle</value>
        </criteriaItems>
        <description>Nidhi&apos;s Function Assignment for S3 Metrics</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>S3 Initial Change Request</fullName>
        <active>false</active>
        <criteriaItems>
            <field>S3_Ops__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>S3 Ops Assignment Owner</fullName>
        <actions>
            <name>SMP1_Metrics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Contact Center,Cross-Functional,Document Management Center,Finance,Human Resources</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Ops Assignment Owner2</fullName>
        <actions>
            <name>SPM2_Metrics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Credentialing Verification,Revenue Cycle</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Ops Assignment Owner3</fullName>
        <actions>
            <name>SPM3_Metrics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Function__c</field>
            <operation>equals</operation>
            <value>Biomedical Technology,Supply Chain</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Ops CAG Update</fullName>
        <actions>
            <name>Update_CAG_Date_AB</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) and 3</booleanFilter>
        <criteriaItems>
            <field>S3_Ops__c.Process_Step__c</field>
            <operation>equals</operation>
            <value>CAG Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Status__c</field>
            <operation>equals</operation>
            <value>CAG Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.OwnerId</field>
            <operation>equals</operation>
            <value>Amanda Baumgartner</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Ops Record Owner</fullName>
        <actions>
            <name>S3_Ops_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Outside Review</fullName>
        <actions>
            <name>Process_Update_CAG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>S3_Ops__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Metric Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Metric_Type__c</field>
            <operation>notEqual</operation>
            <value>IOM</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.Process_Step__c</field>
            <operation>equals</operation>
            <value>Operational Team Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>S3_Ops__c.CAG_Approval__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Technology Approval Notification</fullName>
        <actions>
            <name>S3_SSLT_Change_Request_Result</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>S3_Ops__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected,Retracted</value>
        </criteriaItems>
        <description>Notify IS partner when approval of technology has been made by SSLT (deployment, purchase, etc)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Approve_Change_Request</fullName>
        <assignedTo>daltone@sutterhealth.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>S3_Ops__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Approve Change Request</subject>
    </tasks>
    <tasks>
        <fullName>Change_Request_Approval</fullName>
        <assignedTo>daltone@sutterhealth.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>S3_Ops__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change Request Approval</subject>
    </tasks>
    <tasks>
        <fullName>Change_Request_Approval_HR</fullName>
        <assignedTo>rosel@sutterhealth.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>S3_Ops__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change Request Approval</subject>
    </tasks>
    <tasks>
        <fullName>Update_CAG_Date_AB</fullName>
        <assignedTo>baumgaal@sutterhealth.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>S3_Ops__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update CAG Date</subject>
    </tasks>
</Workflow>
