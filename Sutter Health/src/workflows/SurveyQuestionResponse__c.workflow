<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Q1_Score_Update</fullName>
        <field>Q1_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;I received the information that I was seeking.&quot;, Response_Score__c ,0)</formula>
        <name>Q1 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q1_Score_Update_New2</fullName>
        <field>Q1_Score__c</field>
        <formula>IF( CONTAINS(Survey_Question__r.Question__c,&quot;Was your issue resolved?&quot;), if(CONTAINS(Response__c,&quot;Yes&quot;),1,0) ,0)</formula>
        <name>Q1 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q1_Score_Update_OLD_Survey</fullName>
        <field>Q1_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;I received the information that I was seeking.&quot;, Response_Score__c ,0)</formula>
        <name>Q1 Score Update OLD Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q2_Score_Update_OLD_Survey</fullName>
        <field>Q2_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;This call was a pleasant experience.&quot;, Response_Score__c ,0)</formula>
        <name>Q2 Score Update OLD Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q3_Score_Update</fullName>
        <field>Q3_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How satisfied were you with the customer service representative&apos;s understanding of your issue today?&quot;, Response_Score__c ,0)</formula>
        <name>Q3 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q3_Score_Update_OLD_Survey</fullName>
        <field>Q3_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How satisfied were you with the customer service representative&apos;s understanding of your issue today?&quot;, Response_Score__c ,0)</formula>
        <name>Q3 Score Update OLD Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q4_Score_Update_OLD_Survey</fullName>
        <field>Q4_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How satisfied were you with the customer service representative&apos;s understanding of your issue today?&quot;, Response_Score__c ,0)</formula>
        <name>Q4 Score Update OLD Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q_2_Score_Update</fullName>
        <field>Q2_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How many times have you contacted Sutter Shared Services (S3) about this issue?&quot;, if(Response__c = &apos;1&apos;,1,if(Response__c = &apos;2&apos;,2,3)) ,0)</formula>
        <name>Q2 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q_3_Score_Update</fullName>
        <field>Q3_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c= &quot;How would you rate the quality of the service you received from the agent who assisted you?&quot;, Response_Score__c ,0)</formula>
        <name>Q3 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Q_4_Score_Update</fullName>
        <field>Q4_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How likely is it that you would recommend the Sutter Shared Services (S3) Contact Center to a colleague?&quot;, Response_Score__c ,0)</formula>
        <name>Q4 Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Translate_survey_response_to_number</fullName>
        <field>Response_Score__c</field>
        <formula>IF(AND(OR(Response__c &lt;&gt; null, Response__c &lt;&gt; &apos;&apos;), ISNUMBER(TRIM(Response__c))),VALUE(TRIM(Response__c)),0)</formula>
        <name>Translate survey response to number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Q2_Score</fullName>
        <field>Q2_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;This call was a pleasant experience.&quot;, Response_Score__c ,0)</formula>
        <name>Update Q2 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Q4_Score</fullName>
        <field>Q4_Score__c</field>
        <formula>IF( Survey_Question__r.Question__c =&quot;How would you rate your overall satisfaction?&quot;, Response_Score__c ,0)</formula>
        <name>Update Q4 Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Q1 Score</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>contains</operation>
            <value>Was your issue resolved?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q1 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q1_Score_Update_New2</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q1 Score OLD Survey</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>equals</operation>
            <value>I received the information that I was seeking.</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q1 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q1_Score_Update_OLD_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q2 Score</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>equals</operation>
            <value>How many times have you contacted Sutter Shared Services (S3) about this issue?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q2 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q_2_Score_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q2 Score OLD Survey</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>equals</operation>
            <value>This call was a pleasant experience.</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q2 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q2_Score_Update_OLD_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q3 Score</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>contains</operation>
            <value>How would you rate the quality of the service you received from the agent who assisted you?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q3 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q_3_Score_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q3 Score OLD Survey</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>equals</operation>
            <value>How satisfied were you with the customer service representative&apos;s understanding of your issue today?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q1 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q3_Score_Update_OLD_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q4 Score</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>contains</operation>
            <value>How likely is it that you would recommend the Sutter Shared Services (S3) Contact Center to a colleague?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q4 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q_4_Score_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Q4 Score OLD Survey</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Question__c.Question__c</field>
            <operation>equals</operation>
            <value>How satisfied were you with the customer service representative&apos;s understanding of your issue today?</value>
        </criteriaItems>
        <description>Workflow Rule for updating the Q1 Score value so that it can be rolled up to Survey Taken</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Q4_Score_Update_OLD_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Survey Response Score</fullName>
        <actions>
            <name>Translate_survey_response_to_number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SurveyQuestionResponse__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Survey Response score based on the response provided by the user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
