<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PDIEAProviderCallCenterValidationConfirmationEmail</fullName>
        <description>PDIEA_Provider Cal lCenter Validation Confirmation Email</description>
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
        <fullName>Success_E_Mail</fullName>
        <description>Success E-Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Provider_Templates/Provider_Community_Validation_Confirmation_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Address_Type</fullName>
        <description>Populate primary address based on Serial Number.</description>
        <field>Address_Type__c</field>
        <literalValue>Primary</literalValue>
        <name>Address Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Communication_Preferences_HIM</fullName>
        <field>Communication_Preferences_HIM__c</field>
        <literalValue>Printed Letter</literalValue>
        <name>Communication Preferences – HIM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_FirstName_Update</fullName>
        <description>Provider First Name Update</description>
        <field>First_Name__c</field>
        <formula>Contact_Id__r.FirstName</formula>
        <name>Provider FirstName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_ID_Upsert</fullName>
        <field>Provider_ID__c</field>
        <formula>Contact_Id__r.Contact_External_ID1__c</formula>
        <name>Provider ID Upsert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_LastName_Update</fullName>
        <description>Provider Last Name</description>
        <field>Last_Name__c</field>
        <formula>Contact_Id__r.LastName</formula>
        <name>Provider LastName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_MiddleName_Update</fullName>
        <description>Provider Middle Name</description>
        <field>Middle_Name__c</field>
        <formula>Contact_Id__r.Contact_Middle_Name__c</formula>
        <name>Provider MiddleName Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Preferred_Communication_Method</fullName>
        <field>Preferred_Communication_Method__c</field>
        <name>Update Preferred Communication Method</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Address Type</fullName>
        <actions>
            <name>Address_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Serial_Number__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Populate primary address typed based on Serial Number.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Communication Pref HIM</fullName>
        <actions>
            <name>Communication_Preferences_HIM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Communication_Preferences_HIM__c</field>
            <operation>contains</operation>
            <value>Printed Letter</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDIWF_Provider Call Center Validation Confirmation Email</fullName>
        <actions>
            <name>PDIEAProviderCallCenterValidationConfirmationEmail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>PDV Community Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Tech_Success_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Email__c</field>
            <operation>notContain</operation>
            <value>noreply</value>
        </criteriaItems>
        <description>Used to trigger the email to provider when the call center agent validate the provider details.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Preferred Communication Method Update for No Change</fullName>
        <actions>
            <name>Update_Preferred_Communication_Method</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.Preferred_Communication_Method__c</field>
            <operation>equals</operation>
            <value>No Change</value>
        </criteriaItems>
        <description>Set Preferred Communication Method to NULL for No Change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Provider ID Upsert</fullName>
        <actions>
            <name>Provider_ID_Upsert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Provider Id Upsert on Audit record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Name Update</fullName>
        <actions>
            <name>Provider_FirstName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Provider_LastName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Provider_MiddleName_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Validation_Audit_Trail__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Provider Name Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Validate Portal User</fullName>
        <actions>
            <name>Success_E_Mail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Owner:User.Profile.Name = &apos;PDV Community Provider&apos;,  (Tech_Success_Email__c  == true),NOT(ISNULL(CreatedDate))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
