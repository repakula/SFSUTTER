<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PDI_Provider_Cal_lCenter_Validation_Confirmation_Email_Alert</fullName>
        <description>PDI_Provider Cal lCenter Validation Confirmation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Provider_Templates/PDI_Call_Center_Provider_Validation_Confirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>Portal_Admin_Assistant_Success_E_Mail</fullName>
        <description>Portal Admin Assistant Success E-Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Admin_Assistant_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Provider_Templates/Provider_Community_Validation_Confirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>Portal_Success_E_Mail</fullName>
        <description>Portal Success E-Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Provider_Templates/Provider_Community_Validation_Confirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>Provider_Validation_Reminder_Email_Alert</fullName>
        <description>Provider Validation Reminder Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Provider_Templates/Provider_Community_Follow_Up_Emails</template>
    </alerts>
    <fieldUpdates>
        <fullName>PDI_UpdateTechValidationStatus</fullName>
        <description>Used to update validation status field</description>
        <field>Tech_Validation_Status__c</field>
        <formula>IF(ISBLANK( Validation_Source_Channel__c) , &apos;Non-Validated&apos;, 
IF(Validation_Source_Channel__c == &apos;SFPP&apos;, &apos;Email Campaign&apos;, 
IF(Validation_Source_Channel__c == &apos;SFPA&apos;, &apos;Call Campaign&apos;, &apos;&apos;)))</formula>
        <name>PDI_UpdateTechValidationStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_No_of_Reminders</fullName>
        <field>No_of_Reminders__c</field>
        <formula>No_of_Reminders__c + 1</formula>
        <name>Update No of Reminders</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isPhoneChanged_Field</fullName>
        <field>Is_Phone_Mobile_Fax_Changed_Field__c</field>
        <literalValue>1</literalValue>
        <name>Update isPhoneChanged Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Is_Phone_Mobile_Fax_Changed</fullName>
        <actions>
            <name>Update_isPhoneChanged_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(  ISCHANGED(Mobile_Phone__c),  ISCHANGED(Secure_Phone__c),  ISCHANGED(Secure_Fax__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDI Admin Assistant Validation Confirmation Email</fullName>
        <actions>
            <name>Portal_Admin_Assistant_Success_E_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Owner:User.Profile.Name = &apos;PDI Community Admin Assistant&apos;, (Tech_Success_Email__c == true),NOT(ISNULL(CreatedDate)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDI Validate Portal User</fullName>
        <actions>
            <name>Portal_Success_E_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Owner:User.Profile.Name = &apos;PDV Community Provider&apos;, (Tech_Success_Email__c == true),NOT(ISNULL(CreatedDate)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDI_Provider Call Center Validation Confirmation Email</fullName>
        <actions>
            <name>PDI_Provider_Cal_lCenter_Validation_Confirmation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>PDV Community Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>PDI Community Admin Assistant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Summary__c.Tech_Success_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Summary__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Summary__c.Email__c</field>
            <operation>notContain</operation>
            <value>noreply</value>
        </criteriaItems>
        <description>Call Center Validation Confirmation Email to providers who are validated through call campaign Console</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDI_UpdateValidationStatus</fullName>
        <actions>
            <name>PDI_UpdateTechValidationStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact_Validation_Summary__c.Tech_Current_Campaign__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used for reporting purpose</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Validation Reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact_Validation_Summary__c.Last_Verified_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Provider_Validation_Reminder_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_No_of_Reminders</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact_Validation_Summary__c.CreatedDate</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Provider_Validation_Reminder_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_No_of_Reminders</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact_Validation_Summary__c.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Provider_Validation_Reminder_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_No_of_Reminders</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact_Validation_Summary__c.CreatedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
