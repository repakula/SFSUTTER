<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Account_Owner_When_Broker_License_Nears_its_Expiration</fullName>
        <description>Email Account Owner When Broker License Nears its Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Broker_License_Expiration</template>
    </alerts>
    <alerts>
        <fullName>Email_Broker_Contact_Owner_for_License_Expiration</fullName>
        <description>Email Broker Contact Owner for License Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/Notification_to_Broker_Contact_Owner_for_License_Expiration</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SHP_Broker_Contact</fullName>
        <description>Survey Email to SHP Broker Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SHP_Contact_Broker</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Email_blank_field_update</fullName>
        <field>Email</field>
        <name>Contact Email blank field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Email_blank_field_update_new</fullName>
        <field>Email</field>
        <name>Contact Email blank field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_External</fullName>
        <field>Contact_External_ID1__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>update Contact External Id Broker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDI_Admin_Email_Alert_Flag_Update</fullName>
        <field>Email_Alert__c</field>
        <formula>&quot;YES&quot;</formula>
        <name>PDI_Admin Email Alert Flag Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDV_Email_Alert_Flag_Update</fullName>
        <field>Email_Alert__c</field>
        <formula>&quot;YES&quot;</formula>
        <name>PDV Email Alert Flag Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SMD</fullName>
        <field>SHP_Sent_License_Expiration_Date__c</field>
        <formula>License_Expiration_Date__c</formula>
        <name>Set SMD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SMD_to_30plus</fullName>
        <field>SHP_Sent_License_Expiration_Date__c</field>
        <formula>SHP_Sent_License_Expiration_Date__c +30</formula>
        <name>Set SMD to 30plus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TeleForm_Email_Field_update</fullName>
        <field>TeleForm_Email__c</field>
        <formula>Email</formula>
        <name>TeleForm Email Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Record_Type</fullName>
        <description>Update Contact Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Sales_Employer_Contact_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Contact Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_with_Work_Email</fullName>
        <field>Email</field>
        <formula>Employee_Work_Email__c</formula>
        <name>Update Email with Work Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Healthrules_HCC_ID_Broker</fullName>
        <field>HealthRules_ID__c</field>
        <formula>SFDC_Auto_Number__c</formula>
        <name>Update Healthrules HCC ID Broker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Date</fullName>
        <field>SHP_Survey_Sent_Date__c</field>
        <formula>today()+14</formula>
        <name>Update Survey Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateMemberId</fullName>
        <description>This updates the field on the Member Id</description>
        <field>MemberIdField__c</field>
        <formula>If(CONTAINS(If(CONTAINS(Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),Member_HCC_ID__c),&apos;-&apos;),SUBSTITUTE(If(CONTAINS(Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),Member_HCC_ID__c), &apos;-&apos;,&apos;&apos;),If(CONTAINS(Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),Member_HCC_ID__c))</formula>
        <name>updateMemberId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_mailing_county_on_Contact</fullName>
        <field>Mailing_County__c</field>
        <formula>Account.Physical_County__c</formula>
        <name>update mailing county on Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Broker License Expiration</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.License_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify Contact Owner 60 days prior to Broker License expiration</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Account_Owner_When_Broker_License_Nears_its_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.License_Expiration_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Broker License Expiration Set reminder date</fullName>
        <actions>
            <name>Set_SMD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(RecordType.Name = &apos;SHP Sales Broker Contact&apos; || RecordType.Name = &apos;SHP Sales Broker Contact Read Only&apos;) &amp;&amp; ( ISNEW() || ISCHANGED( License_Expiration_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact HealthRules ID Populated</fullName>
        <actions>
            <name>Update_Contact_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.HealthRules_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Contact</value>
        </criteriaItems>
        <description>This rule will flip the SHP Sales Contact Record Type to a Read Only record type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Physical county of Account to Mailing County of Contact</fullName>
        <actions>
            <name>update_mailing_county_on_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact,SHP Sales Broker Contact Read Only,SHP Sales Employer Contact,SHP Sales Employer Contact Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Mailing_County__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copy Work Email to Email</fullName>
        <actions>
            <name>Update_Email_with_Work_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Employee_Work_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDI_Admin Contact Email Alert Flag</fullName>
        <actions>
            <name>PDI_Admin_Email_Alert_Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update Email Alert Flag as &apos;Yes&apos; on Admin Assistant Contacts.</description>
        <formula>AND(ISCHANGED( Email ), NOT(ISNULL(PRIORVALUE(Email))), RecordType.DeveloperName =&apos;Provider_Admin_Assistant&apos;, PRIORVALUE(Email)&lt;&gt; &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDV Email Alert Flag Update</fullName>
        <actions>
            <name>PDV_Email_Alert_Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(ISCHANGED( Email ), AND( ISCHANGED( Source_of_E_mail__c ), Source_of_E_mail__c = &apos;TLFM&apos;) ) , NOT(ISNULL(PRIORVALUE(Email))), RecordType.DeveloperName =&apos;Provider&apos;,PRIORVALUE(Email)&lt;&gt; &apos;&apos;,NOT(ISPICKVAL(Provider_Service_Status__c,&apos;Retired&apos;)), NOT(ISPICKVAL(Provider_Service_Status__c,&apos;Resigned&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Broker Contact External ID update</fullName>
        <actions>
            <name>Contact_External</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Healthrules_HCC_ID_Broker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact,SHP Sales Employer Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Contact_External_ID1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Mail Broker Contact Expiration</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.SHP_Sent_License_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact,SHP Sales Broker Contact Read Only</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Broker_Contact_Owner_for_License_Expiration</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_SMD_to_30plus</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.SHP_Sent_License_Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Survey Request for a SHP Broker  Contact</fullName>
        <actions>
            <name>Survey_Email_to_SHP_Broker_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Broker_Agent_Status__c</field>
            <operation>equals</operation>
            <value>Contracted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Sales Broker Contact,SHP Sales Broker Contact Read Only</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TeleForm Email Updation</fullName>
        <actions>
            <name>Contact_Email_blank_field_update_new</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TeleForm_Email_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The workflow copies the Standard Email field value to TeleForm Email value.</description>
        <formula>AND(NOT(ISNEW()),CONTAINS( UPPER(Source_of_E_mail__c) , &apos;TLFM&apos;), OR(ISNULL(Username__c),ISBLANK(Username__c)), RecordType.DeveloperName = &apos;Provider&apos;, OR(ISNULL(PRIORVALUE(Email)),ISBLANK(PRIORVALUE(Email))),NOT(ISNULL(Email)), NOT(BEGINS(Email,&apos;testpdv@dummypdv&apos;)),NOT(ISPICKVAL(Provider_Service_Status__c,&apos;Retired&apos;)),NOT(ISPICKVAL(Provider_Service_Status__c,&apos;Resigned&apos;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>updateMemberId</fullName>
        <actions>
            <name>updateMemberId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Member_HCC_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
