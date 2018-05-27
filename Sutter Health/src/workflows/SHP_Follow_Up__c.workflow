<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Capture_First_Call_Date</fullName>
        <field>First_Call_Date__c</field>
        <formula>Now()</formula>
        <name>Capture First Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_First_Call_User</fullName>
        <field>First_Call__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp;  $User.LastName</formula>
        <name>Capture First Call User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Fourth_Call_Date</fullName>
        <field>Fourth_Call_Date__c</field>
        <formula>Now()</formula>
        <name>Capture Fourth Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Fourth_Call_User</fullName>
        <field>Fourth_Call__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Capture Fourth Call User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Second_Call_Date</fullName>
        <field>Second_Call_Date__c</field>
        <formula>Now()</formula>
        <name>Capture Second Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Second_Call_User</fullName>
        <field>Second_Call__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Capture Second Call User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Third_Call_Date</fullName>
        <field>Third_Call_Date__c</field>
        <formula>Now()</formula>
        <name>Capture Third Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Third_Call_User</fullName>
        <field>Third_Call__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Capture Third Call User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Follow_Up_Call_Date</fullName>
        <field>Follow_Up_Call_Date__c</field>
        <name>Clear Follow-Up Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_IM</fullName>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Complete IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_Scheduling</fullName>
        <field>Status__c</field>
        <literalValue>Scheduling</literalValue>
        <name>Move to Scheduling</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Queue</fullName>
        <field>PSR_Queue__c</field>
        <literalValue>1</literalValue>
        <name>PSR Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Return_To_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_PSR_Onboarding</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Return To Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Follow_Up_Date</fullName>
        <field>Follow_Up_Call_Date__c</field>
        <formula>Follow_Up_Call__c</formula>
        <name>Set Follow-Up Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_FollowUp_Date</fullName>
        <field>Last_Follow_Up_Date__c</field>
        <formula>today()</formula>
        <name>Set Last FollowUp Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SHP_Process</fullName>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Update SHP Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>clear_followup_time</fullName>
        <field>Call_Back_time_PST__c</field>
        <name>clear followup time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_comments</fullName>
        <field>Last_Follow_Up_Comment__c</field>
        <formula>Comments__c</formula>
        <name>set comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_follow_up_time</fullName>
        <field>Call_Back_time_PST__c</field>
        <formula>TEXT(Call_Back_time_PST__c)</formula>
        <name>set follow up time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Identify_Member__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Assign Back To Queue</fullName>
        <actions>
            <name>Return_To_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Call_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Identify_Member__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Clear Follow-Up Call Date</fullName>
        <actions>
            <name>Clear_Follow_Up_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>clear_followup_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Activity__c</field>
            <operation>notEqual</operation>
            <value>Spoke with Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Call_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Follow-Up Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Follow_Up_Call__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copy Comments</fullName>
        <actions>
            <name>set_comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Comments__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate IM</fullName>
        <actions>
            <name>Complete_IM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Activity__c</field>
            <operation>equals</operation>
            <value>Duplicate</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>First FollowUp</fullName>
        <actions>
            <name>Capture_First_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_First_Call_User</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>First Follow up created</description>
        <formula>AND(Identify_Member__r.Follow_Up_Count__c = 0, NOT(ISPICKVAL(Call_Outcome__c, &apos;Follow-Up Requested&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Follow-Up Call</fullName>
        <actions>
            <name>Set_Follow_Up_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>set_follow_up_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Activity__c</field>
            <operation>equals</operation>
            <value>Spoke with Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Follow-Up Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>SHP_Follow_Up__c.Follow_Up_Call__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FollowUp Created</fullName>
        <actions>
            <name>Set_Last_FollowUp_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FollowUp MSR</fullName>
        <actions>
            <name>Move_to_Scheduling</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Follow up created and complete and during enrollment call</description>
        <formula>AND(ISPICKVAL(Identify_Member__r.Status__c, &apos;Enrollment&apos;), Identify_Member__r.Follow_Up_Count__c = 0)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FollowUp PSR Complete</fullName>
        <actions>
            <name>Update_SHP_Process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Follow up created by PSR and completed and is not the initial enrollment call</description>
        <formula>AND(ISPICKVAL(Call_Outcome__c, &apos;Complete&apos;),  NOT(ISBLANK( Identify_Member__r.First_Call_Date__c )) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fourth FollowUp</fullName>
        <actions>
            <name>Capture_Fourth_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Fourth_Call_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fourth Follow up created</description>
        <formula>AND(Identify_Member__r.Follow_Up_Count__c = 3, NOT(ISPICKVAL(Call_Outcome__c, &apos;Follow-Up Requested&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Second FollowUp</fullName>
        <actions>
            <name>Capture_Second_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Second_Call_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Second Follow up created</description>
        <formula>AND(Identify_Member__r.Follow_Up_Count__c = 1, NOT(ISPICKVAL(Call_Outcome__c, &apos;Follow-Up Requested&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Third FollowUp</fullName>
        <actions>
            <name>Capture_Third_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Third_Call_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Third Follow up created</description>
        <formula>AND(Identify_Member__r.Follow_Up_Count__c = 2, NOT(ISPICKVAL(Call_Outcome__c, &apos;Follow-Up Requested&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
