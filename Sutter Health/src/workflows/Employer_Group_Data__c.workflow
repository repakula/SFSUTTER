<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_SHP_Interface_and_Creator</fullName>
        <ccEmails>servicedesk@sutterhealth.org, SHPInterfaceTeam@sutterhealth.org</ccEmails>
        <description>Email to SHP Interface and Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Enrollment_team_Notification_on_Approved_SCN</template>
    </alerts>
    <alerts>
        <fullName>New_SCN_Created_Notification</fullName>
        <description>New SCN Created Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Enrollment_SCN_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/New_SCN</template>
    </alerts>
    <alerts>
        <fullName>Notification_On_SCN_DGR_Creation_after_SSO_Approval</fullName>
        <description>Notification On SCN DGR Creation after SSO Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SSO_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Rejected_SCN_Email_Notification</fullName>
        <description>Rejected SCN Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SCN_Rejected_by_Enrollment_Team</template>
    </alerts>
    <alerts>
        <fullName>SCN_Approved_Notification</fullName>
        <description>SCN Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SCN_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>SCN_Rejection_by_SHP_Enrollment_QA</fullName>
        <description>SCN Rejection by SHP Enrollment QA</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SCN_Rejected_by_SHP_Enrollment_QA</template>
    </alerts>
    <alerts>
        <fullName>SCN_rejected_by_Underwriter_queue</fullName>
        <description>SCN rejected by Underwriter queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/SCN_rejected_by_Underwriting</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SCN_Employer_Contact</fullName>
        <description>Survey Email to SCN Employer Contact</description>
        <protected>false</protected>
        <recipients>
            <field>HREnrollment_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SCN_Employer_Contact</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SCN_Employer_Contact_for_Billing</fullName>
        <description>Survey Email to SCN Employer Contact for Billing</description>
        <protected>false</protected>
        <recipients>
            <field>BillingContact_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SCN_Employer_Contact_for_billing_contact</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_Enrollement_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Enrollment_SCN</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Enrollement Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Stage_to_Underwriting_Review</fullName>
        <description>Change Stage to Underwriting Review on submitting SCN</description>
        <field>Stage__c</field>
        <literalValue>Underwriting Review</literalValue>
        <name>Change Stage to Underwriting Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_owner_to_Enrollment_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Enrollment_SCN</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change owner to Enrollment queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_owner_to_SHP_Enrollment_QA_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Enrollment_QA_queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change owner to SHP Enrollment QA queue</name>
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
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_by_SHP_enrollment</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected by SHP enrollment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SCN_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>SCN Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SCN_Completed</fullName>
        <field>Stage__c</field>
        <literalValue>Completed</literalValue>
        <name>SCN Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SCN_stage_to_QA_passed</fullName>
        <field>Stage__c</field>
        <literalValue>Enrollment QA Pass</literalValue>
        <name>Set SCN stage to QA passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_date_Field_Of_SCN</fullName>
        <field>SCN_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approval date Field Of SCN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Cloned_Record_Checkbox</fullName>
        <field>Cloned_Record__c</field>
        <literalValue>1</literalValue>
        <name>Update Cloned Record Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SCN_Survey_sent_date</fullName>
        <field>SCN_Survey_Sent_Date__c</field>
        <formula>today()+14</formula>
        <name>Update SCN Survey sent date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Field_to_Draft</fullName>
        <field>Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Stage Field to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Stage to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Rejected_by_Underwriter</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Stage to Rejected by Underwriter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_QA</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted for QA</literalValue>
        <name>Update Status to QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tech_Cloned_Record</fullName>
        <field>Tech_Cloned_Record__c</field>
        <literalValue>1</literalValue>
        <name>Update Tech Cloned Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Underwriting_start_time</fullName>
        <field>Underwriting_Start_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Underwriting start time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>owner_set_to_Enrollment_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Enrollment_SCN</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>owner set to Enrollment Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>owner_set_to_Underwriter_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Underwriter_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>owner set to Underwriter Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_field_update_to_QA_failed</fullName>
        <field>Stage__c</field>
        <literalValue>Enrollment QA Fail</literalValue>
        <name>set field update to QA failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_Have_Plan_Numbers_Changed</fullName>
        <field>Have_the_plan_numbers_changed__c</field>
        <literalValue>0</literalValue>
        <name>uncheck Have Plan Numbers Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Have_Plan_Numbers_Changed</fullName>
        <field>Have_the_plan_numbers_changed__c</field>
        <literalValue>1</literalValue>
        <name>update Have Plan Numbers Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updatedraftstarttimeoncreation</fullName>
        <field>Draft_Start_Time__c</field>
        <formula>NOW()</formula>
        <name>updateDraft Start time on creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign to Enrollement Queue</fullName>
        <actions>
            <name>Assign_to_Enrollement_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Employer_Group_Data__c.Stage__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Cloned Record or Not</fullName>
        <actions>
            <name>Update_Cloned_Record_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tech_Cloned_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used to check the record is cloned or not</description>
        <formula>ISCLONE()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Final Aprroved</fullName>
        <actions>
            <name>Email_to_SHP_Interface_and_Creator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employer_Group_Data__c.Stage__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Employer_Group_Data__c.Enrollment_Method__c</field>
            <operation>equals</operation>
            <value>Electronic</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Sales on SCN Creation</fullName>
        <actions>
            <name>Notification_On_SCN_DGR_Creation_after_SSO_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( Sold_Sign_Off__c ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a Sent to Employer contact</fullName>
        <actions>
            <name>Survey_Email_to_SCN_Employer_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_SCN_Survey_sent_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL( Stage__c , &apos;Approved&apos;),AND( or( HREnrollment_Name__r.RecordTypeId = &apos;012G0000000jglo&apos;,HREnrollment_Name__r.RecordTypeId = &apos;012G0000000jglp&apos;),OR(HREnrollment_Name__r.Email &lt;&gt; null , BillingContact_Name__r.Email &lt;&gt; null) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a Sent to Employer contact for Billing</fullName>
        <actions>
            <name>Survey_Email_to_SCN_Employer_Contact_for_Billing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_SCN_Survey_sent_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Stage__c , &apos;Approved&apos;),AND( or( HREnrollment_Name__r.RecordTypeId  = &apos;012G0000000jglo&apos;,HREnrollment_Name__r.RecordTypeId  = &apos;012G0000000jglp&apos;),HREnrollment_Name__r.Email &lt;&gt; BillingContact_Name__r.Email ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Draft Start Time</fullName>
        <actions>
            <name>updatedraftstarttimeoncreation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employer_Group_Data__c.Stage__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Underwriting Start time on Directly sending to underwriting</fullName>
        <actions>
            <name>Update_Underwriting_start_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employer_Group_Data__c.Stage__c</field>
            <operation>equals</operation>
            <value>Underwriting Review</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>uncheck Have Plan Numbers Changed</fullName>
        <actions>
            <name>uncheck_Have_Plan_Numbers_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(OR(ISNEW(),Text(Group_Type__c) !=&apos;Small&apos;),Opportunity__r.Renewed_Opportunity__c = false),AND(ISCHANGED(Group_Type__c ),Text(Group_Type__c) != &apos;Small&apos;,Opportunity__r.Renewed_Opportunity__c = false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update Have Plan Numbers Changed on SCN</fullName>
        <actions>
            <name>update_Have_Plan_Numbers_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Small Group is selected in &apos;Group Type&apos;, “Have Plan Numbers Changed” should be defaulted to yes</description>
        <formula>OR(AND(OR(ISNEW(),Text(Group_Type__c) ==&apos;Small&apos;),Opportunity__r.Renewed_Opportunity__c = true),AND(ISCHANGED(Group_Type__c ),Text(Group_Type__c) == &apos;Small&apos;,Opportunity__r.Renewed_Opportunity__c = true))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
