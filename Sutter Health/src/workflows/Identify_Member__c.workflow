<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign_to_60_Day_Follow_Up_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>X60_Day_Follow_Up</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to 60 Day Follow Up Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_PSR_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_PSR_Onboarding</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to PSR Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>Now()</formula>
        <name>Capture Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Process</fullName>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Complete Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Status</fullName>
        <field>Status__c</field>
        <literalValue>Enrollment</literalValue>
        <name>Default Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_60_day_queue</fullName>
        <field>X60_day_queue__c</field>
        <literalValue>1</literalValue>
        <name>Flag 60 day queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_in_PSR_stage</fullName>
        <field>PSR_Queue__c</field>
        <literalValue>1</literalValue>
        <name>Flag in PSR stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_psr_assigned</fullName>
        <field>PSR_Queue_Assigned__c</field>
        <literalValue>1</literalValue>
        <name>Flag psr assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Queue</fullName>
        <field>PSR_Queue__c</field>
        <literalValue>0</literalValue>
        <name>Remove Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_MSR_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_MSR_Onboarding</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SHP MSR Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign back to 60 day Queue</fullName>
        <active>true</active>
        <formula>AND(X60_day_queue__c, NOT(ISPICKVAL(Status__c,&apos;Complete&apos;)),
Owner:Queue.Name != &apos;60 Day Follow Up&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_60_Day_Follow_Up_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Identify_Member__c.LastModifiedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Assign back to MSR Queue</fullName>
        <active>true</active>
        <formula>AND(!PSR_Queue__c, !PSR_Queue_Assigned__c, Follow_Up_Count__c &lt; 3, NOT(ISPICKVAL(Status__c,&apos;Complete&apos;)),NOT(ISPICKVAL(Status__c,&apos;Incomplete&apos;)),
Owner:Queue.Name != &apos;SHP_MSR_Onboarding&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SHP_MSR_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Identify_Member__c.LastModifiedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Assign back to PSR Queue</fullName>
        <active>true</active>
        <formula>AND(!X60_day_queue__c, PSR_Queue__c, PSR_Queue_Assigned__c, Follow_Up_Count__c &lt; 3, NOT(ISPICKVAL(Status__c,&apos;Complete&apos;)),
Owner:Queue.Name != &apos;SHP_PSR_Onboarding&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_PSR_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Identify_Member__c.LastModifiedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Assign to 60 day Queue</fullName>
        <actions>
            <name>Flag_60_day_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(X60_day_queue__c),
Owner:Queue.Name = &apos;60 Day Follow Up&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Care Everywhere</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Identify_Member__c.High_Priority__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completed</fullName>
        <actions>
            <name>Capture_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Identify_Member__c.Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Queue</fullName>
        <actions>
            <name>Default_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Identify_Member__c.Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Do Not Call</fullName>
        <actions>
            <name>Complete_Process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Identify_Member__c.Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Flag PSR Queue</fullName>
        <actions>
            <name>Flag_in_PSR_stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Flag_psr_assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>flags to be in psr queue if manually assigned</description>
        <formula>AND(NOT(AND(PSR_Queue__c, PSR_Queue_Assigned__c)), 
Contains(Owner:Queue.Name,&apos;SHP PSR Onboarding&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Flag as assigned to psr</fullName>
        <actions>
            <name>Flag_psr_assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Record ownership was changed to a PSR</description>
        <formula>CONTAINS(Owner:User.Profile.Name , &apos;PSR&apos;) &amp;&amp; PSR_Queue__c &amp;&amp; Not(PSR_Queue_Assigned__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Onboarding MSR Queue</fullName>
        <actions>
            <name>SHP_MSR_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Identify_Member__c.Status__c</field>
            <operation>equals</operation>
            <value>Enrollment</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SHP Onboarding PSR Queue</fullName>
        <active>true</active>
        <formula>AND(!X60_day_queue__c,PSR_Queue__c, NOT(PSR_Queue_Assigned__c), NOT(ISPICKVAL(Status__c,&apos;Complete&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_PSR_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Flag_psr_assigned</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Identify_Member__c.First_Call_Date__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SHP Onboarding return toMSR Queue</fullName>
        <active>false</active>
        <formula>AND(Not(isblank(First_Call_Date__c)), Not( isblank( Second_Call_Date__c )),
Not(isblank( Third_Call_Date__c )),
NOT(ISPICKVAL(Status__c,&apos;Complete&apos;)),  Owner:Queue.DeveloperName != &apos;SHP MSR Onboarding&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SHP_MSR_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
