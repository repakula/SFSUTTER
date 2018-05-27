<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSAT_Survey_Request_for_S3_SR_Contact</fullName>
        <description>Survey Email to S3 SR Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_CSAT_Survey_Email_to_S3_Contact</template>
    </alerts>
    <alerts>
        <fullName>CV_2_Days_Alert</fullName>
        <description>CV 2 Days Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>baumgaal@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CV_Template_2_Days</template>
    </alerts>
    <alerts>
        <fullName>CV_90_mins_Alert</fullName>
        <description>CV 90 mins Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>baumgaal@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CV_Template_90_Mins</template>
    </alerts>
    <alerts>
        <fullName>CV_Expedited_1_Day_Alert</fullName>
        <description>CV Expedited 1 Day Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>baumgaal@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CV_Template_1_Day</template>
    </alerts>
    <alerts>
        <fullName>CV_Standard_2_Day_Alert</fullName>
        <description>CV Standard 2 Day Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>baumgaal@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CV_Template_2_Days</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_Breaches</fullName>
        <description>Credentialing Verification - Breaches</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_Breaches</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_Closed</fullName>
        <description>Credentialing Verification - Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_Closed</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_Escalation</fullName>
        <description>Credentialing Verification - Escalation</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_External_Transfer</fullName>
        <description>Credentialing Verification - External Transfer</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_External_Transfer</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_New</fullName>
        <description>Credentialing Verification - New</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/New_Service_Request</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_On_Hold</fullName>
        <description>Credentialing Verification - On-Hold</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_On_Hold</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_Pending</fullName>
        <description>Credentialing Verification - Pending</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_Pending</template>
    </alerts>
    <alerts>
        <fullName>Credentialing_Verification_Re_assign</fullName>
        <description>Credentialing Verification - Re-assign</description>
        <protected>false</protected>
        <recipients>
            <recipient>S3_CV_Tier_3</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>S3_Templates/Service_Request_Internal_Transfer</template>
    </alerts>
    <alerts>
        <fullName>DMC_Email_Notification</fullName>
        <description>DMC Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DMC_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>DMC_Service_Request_Status_Change_Closed</fullName>
        <description>DMC Service Request Status Change - Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/DMC_Service_Request_Status_Change_Closed</template>
    </alerts>
    <alerts>
        <fullName>DMC_Service_Request_Status_Change_In_Progress</fullName>
        <description>DMC Service Request Status Change - In Progress</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/DMC_Service_Request_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>DMC_Service_Request_Status_Change_New</fullName>
        <description>DMC Service Request Status Change - New</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/DMC_Service_Request_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>DMC_Service_Request_Status_Change_On_Hold</fullName>
        <description>DMC Service Request Status Change - On Hold</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/DMC_Service_Request_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_Grievance_SR</fullName>
        <description>Email Alert for Grievance SR at 21st hour before hitting the 24 hour milestone to expire</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_Exempt_Grievance_before_hitting_the_24_hour_milestone</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_SHP_Claim_Group</fullName>
        <description>SHP Claim Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Claim_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_SHP_Sales_Mailing_Group</fullName>
        <description>Email Alert to SHP Sales Mailing Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Case_Originator_After_Case_Closed</fullName>
        <description>Email Notification to Case Originator After Case Closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Service/Notify_Originator_about_Closed_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_SHP_Billing_after_5_Days_of_Case_Creation</fullName>
        <description>Email Notification to SHP Billing after 5 Days of Case Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Billing_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_when_SR_is_completed</fullName>
        <description>Email Notification when SR is completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Directory_Inaccuracy_A_G</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Notification_to_PDI_on_SR_Completion</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_sent_when_SRs_are_routed_to_SHP_Member_Services_Portal_Reques</fullName>
        <description>Email notification sent when SRs are routed to SHP Member Services Portal Request queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Services_Portal_Req_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>Employee_Inquiry_New</fullName>
        <description>Employee Inquiry New</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_Employee_Line_New_Service_Request_Notificationv_v2</template>
    </alerts>
    <alerts>
        <fullName>Employee_Portal_Closed_Inquiry_Notification</fullName>
        <description>Employee Portal Closed Inquiry Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/Employee_Portal_Closed_Inquiry_Notification</template>
    </alerts>
    <alerts>
        <fullName>Exempt_Record_SLA_is_violated</fullName>
        <description>Exempt Record SLA is violated</description>
        <protected>false</protected>
        <recipients>
            <recipient>chowak@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ellisc2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fieldc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>greergn@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huettea@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kinneyl1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nguyt2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>regalac1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sotoj6@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomps@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Grievance_Exempt_Record_SLA_is_Violated</template>
    </alerts>
    <alerts>
        <fullName>Grievance_Email_SR_Changed_to_Exempt</fullName>
        <description>Grievance Email SR Changed to Exempt</description>
        <protected>false</protected>
        <recipients>
            <recipient>ellisc2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huettea@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Grievance_Email_Notification_when_SR_Changed_to_Exempt</template>
    </alerts>
    <alerts>
        <fullName>Grievance_Email_SR_Changed_to_NonExempt</fullName>
        <description>Grievance Email SR Changed to NonExempt</description>
        <protected>false</protected>
        <recipients>
            <recipient>buij1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ellisc2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Grievance_Email_Notification_when_SR_Changed_to_NonExempt</template>
    </alerts>
    <alerts>
        <fullName>MU_Escalation_Closed_Alert</fullName>
        <ccEmails>ProviderDataValidationCC@sutterhealth.org</ccEmails>
        <description>MU Escalation Closed Alert</description>
        <protected>false</protected>
        <senderAddress>sutterproviderhub@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MU_Team_Closed_An_Escalated_Case</template>
    </alerts>
    <alerts>
        <fullName>Milestone_Violations</fullName>
        <description>Milestone Violations</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Correspondence_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>coxt3@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Correspondence_Milestones_Violations</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Agent_for_Exempt_Grievance</fullName>
        <description>Notification to Agent for Exempt Grievance</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>A_G_Management_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_to_Agent_for_Exempt_Grievance</template>
    </alerts>
    <alerts>
        <fullName>PDR_Determination_not_set</fullName>
        <description>PDR - Determination not set</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/PDR_Determination_not_Set</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_1_day_before_PDI_SR_is_hitting_the_milestone</fullName>
        <description>Reminder Notification 1 day before PDI SR is hitting the milestone</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_1_day_before_hitting_the_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_1_day_before_Provider_Network_Services_is_hitting_the_mile</fullName>
        <description>Reminder Notification 1 day before Provider Network Services is hitting the milestone</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_1_day_before_hitting_the_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_1day_before_Provider_Network_Services_is_hitting_the_miles</fullName>
        <description>Reminder Notification 1 day before Provider Network Services is hitting the milestone</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Directory_Inaccuracy_A_G</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_1_day_before_hitting_the_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_5_days_before_PDI_SR_is_hitting_the_milestone</fullName>
        <description>Reminder Notification 5 days before PDI SR is hitting the milestone</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Services_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_5_days_before_hitting_the_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_5days_before_PDI_SR_is_hitting_the_milestone</fullName>
        <description>Reminder Notification 5 days before PDI SR is hitting the milestone</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Services_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_5_days_before_hitting_the_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_for_PDI_on_completion_of_mileston</fullName>
        <description>Reminder Notification for PDI on completion of milestone</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_on_completion_of_milestone</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Notification_for_PDI_oncompletion_of_milestone</fullName>
        <description>Reminder Notification for PDI on completion of milestone</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Reminder_Notification_for_PDI_on_completion_of_milestone</template>
    </alerts>
    <alerts>
        <fullName>SHP_Alert_to_SR_Owner_after_5_days_from_Created_Date</fullName>
        <description>SHP Alert to SR Owner after 5 days from Created Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Alert_to_SR_Owner_after_5_days_from_Created_Date_with_time_trigger</fullName>
        <description>SHP Alert to SR Owner after 5 days from Created Date with time trigger</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Billing_Group_Notification</fullName>
        <description>SHP Billing Group Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Billing_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Claim_Group_Email_Alert_after_5_Days_of_Creation_for_High_Priority_SR</fullName>
        <description>SHP Claim Group Email Alert after 5 Days of Creation for High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Claim_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Correspondence_Group_Email_Alert_after_Days_of_Creation_for_High_Priority_SR</fullName>
        <description>SHP Correspondence Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Correspondence_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Correspondence_Group_Email_Notification</fullName>
        <description>SHP Correspondence Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Correspondence_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Email_Alert_Call_Back</fullName>
        <description>SHP Email Alert Call Back</description>
        <protected>false</protected>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Call_Back_Queue_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>SHP_Email_Alert_to_Calchoice_Enrollment_Queue</fullName>
        <description>SHP Email Alert to Calchoice Enrollment Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_CalChoice_Enrollment_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Enrollment_Group_Email_Alert_after_5_Days_of_Creation_of_High_Priority_SR</fullName>
        <description>SHP Enrollment Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Enrollment_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Enrollment_Group_Notification</fullName>
        <description>SHP Enrollment Group Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Enrollment_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Grievance_when_Non_Exempt_SR_is_created</fullName>
        <description>SHP Grievance when Non-Exempt SR is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>chowak@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ellisc2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fieldc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>greergn@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huettea@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kinneyl1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nguyt2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>regalac1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simmonl2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sotoj6@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomps@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Grievance_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>SHP_Leagal_Compliance_Group_Email_Alert_after_5_Days_of_Creation_of_High_Priorit</fullName>
        <description>SHP Leagal &amp; Compliance Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Legal_Compliance_Team_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Legal_Compliance_Team_Group_Email_Notification</fullName>
        <description>SHP Legal &amp; Compliance Team Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Legal_Compliance_Team_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Mail_on_Communication_Team_Media_Legal_Threat</fullName>
        <ccEmails>neilsor@sutterhealth.org,</ccEmails>
        <ccEmails>KeatinC1@sutterhealth.org</ccEmails>
        <description>SHP Mail on Communication Team Media/Legal Threat</description>
        <protected>false</protected>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Legal_Threat_Communication_Team</template>
    </alerts>
    <alerts>
        <fullName>SHP_Medical_Review_Unit_Group_Email_Alert_after_5_Days_of_Creation_of_High_Prior</fullName>
        <description>SHP Medical Review Unit Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Medical_Review_Unit_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Medical_Review_Unit_Group_Email_Notification</fullName>
        <description>SHP Medical Review Unit Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Medical_Review_Unit_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_A_G_Email_Alert</fullName>
        <description>SHP Member A&amp;G Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_A_G_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_A_G_Group_Email_Alert_after_5_Days_of_Creation_of_High_Priority_SR</fullName>
        <description>SHP Member A&amp;G Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_A_G_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Grievance_Coordinator_Group_Email_Alert_after_5_Days_of_Creation_of_H</fullName>
        <description>SHP Member Grievance Coordinator Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Grievance_Coordinator_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Grievance_Coordinator_Group_Email_Notification</fullName>
        <description>SHP Member Grievance Coordinator Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Grievance_Coordinator_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Grievance_Exempt_Group_Email_Alert_after_5_Days_of_Creation_of_High_P</fullName>
        <description>SHP Member Grievance - Exempt Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Grievance_Exempt_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Grievance_Exempt_Group_Email_Notification</fullName>
        <description>SHP Member Grievance - Exempt Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Grievance_Exempt_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Service_Call_Back_Email_Notification</fullName>
        <description>SHP Member Service &quot;Call Back&quot; Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Service_Call_Back_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Service_Call_Back_Group_Email_Alert_after_Days_of_Creation_of_High_Pr</fullName>
        <description>SHP Member Service &quot;Call Back&quot; Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Service_Call_Back_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Services_Management_Group_Email_Alert_after_5_Days_of_Creation_of_Hig</fullName>
        <description>SHP Member Services Management Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Services_Management_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Member_Services_Management_Group_Email_Notification</fullName>
        <description>SHP Member Services Management Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Member_Services_Management_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_OOA_OON_Group_Email_Alert_after_5_Days_of_Creation_of_High_Priority_SR</fullName>
        <description>SHP OOA/OON Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_OOA_OON_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_OOA_OON_Group_Email_Notification</fullName>
        <description>SHP OOA/OON Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_OOA_OON_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Sales_Email_Template/New_OOA_OON_SR</template>
    </alerts>
    <alerts>
        <fullName>SHP_Provider_Dispute_Level_2_Group_Email_Notification</fullName>
        <description>SHP Provider Dispute Level 2 Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Dispute_Level_2_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Provider_Dispute_Level_Group_Email_Alert_after_5_Days_of_Creation_of_High_Pr</fullName>
        <description>SHP Provider Dispute Level 2 Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Dispute_Level_2_Mailing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Provider_Services_Group_Email_Alert_after_5_Days_of_Creation_of_High_Priorit</fullName>
        <description>SHP Provider Services Group Email Alert after 5 Days of Creation of High Priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Services_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Provider_Services_Public_Group_Email_Notification</fullName>
        <description>SHP Provider Services Public Group Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Provider_Services_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_notification_to_SHP_Billing</template>
    </alerts>
    <alerts>
        <fullName>SHP_Sales_Mailing_Group_Notification_to_Owner_after_5_days_of_creation_of_High_p</fullName>
        <description>SHP Sales Mailing Group Notification to Owner after 5 days of creation of High priority SR</description>
        <protected>false</protected>
        <recipients>
            <recipient>SHP_Sales_Mailing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SHP_Service/Email_Template_for_Notifying_SHP_SR_Owner_about_Open_Status</template>
    </alerts>
    <alerts>
        <fullName>SHP_Web_Grievance_when_Expedited_SR_is_created</fullName>
        <description>SHP Web Grievance when Expedited SR is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>chowak@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ellisc2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fieldc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>glennj@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>huettea@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nguyt2@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>powellc@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>regalac1@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sotoj6@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomps@sutterhealth.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_Web_Grievance_Email_Notification_when_SR_is_created_for_Expedited</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_S3_SR_Requester</fullName>
        <description>Survey Email to S3 SR Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_CSAT_Survey_Email_to_S3_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_S3_IL_Contact</fullName>
        <description>Survey Email to S3 IL Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_CSAT_Survey_Email_to_S3_Contact</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_S3_IL_Requester</fullName>
        <description>Survey Email to S3 IL Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_CSAT_Survey_Email_to_S3_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SHP_IL_Contact</fullName>
        <description>Survey Email to SHP IL Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SHP_Contact_Member</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SHP_IL_Contact_Portal</fullName>
        <description>Survey Email to SHP IL Contact Portal</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SHP_Contact_Portal</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email_to_SHP_IL_Provider</fullName>
        <description>Survey Email to SHP IL Provider</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SHP_Sales_Email_Template/SHP_CSAT_Survey_Email_to_SHP_Contact_Provider</template>
    </alerts>
    <alerts>
        <fullName>Tier_3_Privacy_Email_Alert</fullName>
        <description>[Tier 3] Privacy Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Tier_3_Privacy</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/New_Service_Request_For_Tier_3_Privacy</template>
    </alerts>
    <alerts>
        <fullName>Vendor_Email_Notification_New</fullName>
        <description>Vendor Email Notification New</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>salesforce@sutterhealth.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>S3_Templates/S3_Vendor_Line_New_Service_Request_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Address_Change_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Address_Change_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Address Change Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Affiliate_Data_Change_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Affiliate_Data_Change_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Affiliate Data Change Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Application_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Application Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Onboarding_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_MSR_Onboarding</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Onboarding Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Call_Back_Completed</fullName>
        <field>Call_Back_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Billing Call Back Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>COC_Request_Recordtyp_to_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>COC_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>COC Request Recordtyp to RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Back_Completed</fullName>
        <field>Call_Back_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Call Back Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Back_Flag</fullName>
        <field>Call_Back__c</field>
        <literalValue>1</literalValue>
        <name>Call Back Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case01_UpdateOwnerToPayroll</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_Payroll_T_E_Compensation</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case01_UpdateOwnerToPayroll</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case02_UpdateOwnerToBenefits</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_HR_Benefits</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case02_UpdateOwnerToBenefits</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case03_UpdateOwnerTo_Tier1_HRPerformance</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_Learning</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case03_UpdateOwnerTo_Tier1_HRPerformance</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case04_UpdateOwnerTo_Tier1_HRRecruitment</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_HR_Recruitment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case04_UpdateOwnerTo_Tier1_HRRecruitment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case04_UpdateOwnerTo_Tier1_PerfLearnWork</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_Learning</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case04_UpdateOwnerTo_Tier1_PerfLearnWork</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case05_UpdateOwnerTo_Tier3_HRReporting</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_3_HR_Reporting</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case05_UpdateOwnerTo_Tier3_HRReporting</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case06_UpdateOwnerTo_Tier1_HRPerformance</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_Learning</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case06_UpdateOwnerTo_Tier1_HRPerformance</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case07_UpdateOwnerTo_Tier1_HRPerformance</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_Learning</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case07_UpdateOwnerTo_Tier1_HRPerformance</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case08_UpdateOwnerTo_Tier1_HRRecruitment</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier_1_HR_Recruitment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case08_UpdateOwnerTo_Tier1_HRRecruitment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Requester_Email_Update</fullName>
        <description>Updates the Case Requester Email field with the Parent Case Requester Email field value.</description>
        <field>Requestor_Email__c</field>
        <formula>Parent_Case_Requester_Email__c</formula>
        <name>Case Requester Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Stopped_to_False</fullName>
        <description>Change the Stopped field to False to restart Entitlement timers</description>
        <field>IsStopped</field>
        <literalValue>0</literalValue>
        <name>Case Stopped to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Claim_Review_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Claim_Review_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Claim Review RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Comment</fullName>
        <field>Internal_Comments__c</field>
        <name>Clear Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Description</fullName>
        <field>Description</field>
        <name>Clear Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Call_Back_Completed</fullName>
        <field>Call_Back_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Complaint Call Back Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Converted_From_Exempt_To_Non_Exempt</fullName>
        <description>Updates if the ticket is coverted from exempt to non exempt</description>
        <field>Converted_From_Exempt_To_Non_Exempt__c</field>
        <literalValue>1</literalValue>
        <name>Converted From Exempt To Non-Exempt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Converted_From_Non_Exempt_To_Exempt</fullName>
        <field>Converted_From_Exempt_To_Non_Exempt__c</field>
        <literalValue>0</literalValue>
        <name>Converted From Non-Exempt To Exempt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Change_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Data_Change_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Data Change Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Management_Center_RO</fullName>
        <description>Update Record type to DMC RO</description>
        <field>RecordTypeId</field>
        <lookupValue>Document_Management_Center_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Document Management Center RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Checkbox</fullName>
        <description>Sets Escalated = True</description>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Escalated Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exempt_Violated</fullName>
        <field>Converted_Exempt_Violated__c</field>
        <literalValue>Yes</literalValue>
        <name>Exempt Violated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expirables_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Expirables_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Expirables Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Accounting_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Finance_Accounting_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Finance Accounting RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Accounts_Payable_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Finance_Accounts_Payable_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Finance Accounts Payable RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Payroll_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Finance_Payroll_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Finance Payroll RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Grievance_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Grievance_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Grievance RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Human_Resource_Web_To_Case_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Human_Resource_Web_To_Case_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Human Resource Web To Case RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Human_Resources_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Human_Resources_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Human Resources RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Member_Services_Call_Back</fullName>
        <field>OwnerId</field>
        <lookupValue>SHP_Member_Service_Call_Back</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Member Services Call Back</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Milestone_Stopped</fullName>
        <field>IsStopped</field>
        <literalValue>1</literalValue>
        <name>Milestone Stopped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_SHP_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Non_SHP_Contact_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Non-SHP RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Reprocessed_Flag</fullName>
        <field>Claim_Not_Reprocessed__c</field>
        <literalValue>1</literalValue>
        <name>Not Reprocessed Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OOA_OON_RO</fullName>
        <description>Update Case Recordtype from OOA/OON to OOA/OON RO on Case Close.</description>
        <field>RecordTypeId</field>
        <lookupValue>OOA_OON_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>OOA/OON RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Other_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Other Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDR_Set_Determination</fullName>
        <field>Determination_set_by_milestone__c</field>
        <literalValue>1</literalValue>
        <name>PDR - Set Determination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_Directory_Inaccuracy_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Provider_Directory_Inaccuracy_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Provider Directory Inaccuracy RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_Dispute_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Provider_Dispute_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Provider Dispute RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reapplication_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Reapplication_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Reapplication Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Report_Request_Change_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Report_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Report Request Change Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_bypass_checkbox</fullName>
        <field>Bypass_Validation__c</field>
        <literalValue>0</literalValue>
        <name>Reset bypass checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rush_Application_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Rush_Application_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Rush Application Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Employee_Inquiry_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Employee_Inquiry_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 Employee Inquiry RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_IL_to_Patient_Interaction_Log</fullName>
        <field>RecordTypeId</field>
        <lookupValue>S3_Patient_Interaction_Log</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 IL to Patient Interaction Log</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_IL_to_RO_RT</fullName>
        <description>Sets RT to S3 interaction Log RO</description>
        <field>RecordTypeId</field>
        <lookupValue>S3_Interaction_Log_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 IL to RO RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Patient_Interaction_Log_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>S3_Patient_Interaction_Log_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 Patient Interaction Log RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Revenue_Cycle_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Revenue_Cycle_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 Revenue Cycle RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>S3_Supply_Chain_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Supply_Chain_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>S3 Supply Chain RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Benefits_SR_to_RT_RO</fullName>
        <description>Set SHP Benefits SR to RO RT on close</description>
        <field>RecordTypeId</field>
        <lookupValue>Benefits_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Benefits SR to RT RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Clinical_Notifications_SR_to_RT_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Clinical_Notifications_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Clinical Notifications SR to RT RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Closed_Billing_RO</fullName>
        <description>Set SHP Billing SR to RT RO</description>
        <field>RecordTypeId</field>
        <lookupValue>Billing_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Closed Billing RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Closed_Eligibility_RO</fullName>
        <description>Set RT to Eligibility RO</description>
        <field>RecordTypeId</field>
        <lookupValue>Eligibility_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Closed Eligibility RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Closed_Enrollment_RO</fullName>
        <description>Set SHP Enrollment RT to RO</description>
        <field>RecordTypeId</field>
        <lookupValue>Enrollment_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Closed Enrollment RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Complaint_RT_to_RO</fullName>
        <description>Set SHP Complaint SR to RO RT</description>
        <field>RecordTypeId</field>
        <lookupValue>Complaint_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Complaint RT to RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Correspondence_RO_Filed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Correspondence_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Correspondence RO Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Documentation_RT_to_RO</fullName>
        <description>Set SHP Documentation SR to RO RT</description>
        <field>RecordTypeId</field>
        <lookupValue>Documentation_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Documentation RT to RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_IL_to_RO_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SHP_Interaction_Log_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP IL to RO RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHP_Portal_Questions_SR_to_RT_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Portal_Questions_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SHP Portal Questions SR to RT RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Created_Yes</fullName>
        <description>Updates Service Request Created? Field to Yes is Parent Case # not equal to 0.</description>
        <field>Service_Request_Created__c</field>
        <literalValue>Yes</literalValue>
        <name>Service Request Created - Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Temporary_Privilege_Request_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CV_Temporary_Privilege_Request_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Temporary Privilege Request RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Training_RO</fullName>
        <description>Changes record typ to training RO on closure</description>
        <field>RecordTypeId</field>
        <lookupValue>Training_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Training RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request</fullName>
        <description>Updating the four fields Function, Sub-Fuction, Customer Intent, Customer Sub-Intent</description>
        <field>Function__c</field>
        <literalValue>Human Resource</literalValue>
        <name>Update Adhoc Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request_Customer_Intent</fullName>
        <field>Customer_Intent__c</field>
        <literalValue>HR Reporting</literalValue>
        <name>Update Adhoc Request Customer Intent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request_Customer_Sub_Intent</fullName>
        <field>Customer_Sub_Intents__c</field>
        <literalValue>Adhoc Report Request Web</literalValue>
        <name>Update Adhoc Request Customer Sub Intent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request_Sub_function</fullName>
        <field>Sub_Function__c</field>
        <literalValue>HR Information System (HRIS)</literalValue>
        <name>Update Adhoc Request Sub function</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request_Subject</fullName>
        <field>Subject</field>
        <formula>CASE( Subject__c, &quot;Employee Roster&quot;, &quot;Employee Roster&quot;,
&quot;New Hire Report&quot;, &quot;New Hire Report&quot;,
&quot;Termination Report&quot;,&quot;Termination Report&quot;,
&quot;Benefits Report&quot;, &quot;Benefits Report&quot;,
&quot;License/Certification Report&quot;, &quot;License/Certification Report&quot;,&quot;Payroll Report&quot;, &quot;Payroll Report&quot;,
&quot;Other&quot;, &quot;Other&quot;, &quot; &quot;)</formula>
        <name>Update Adhoc Request Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adhoc_Request_Team</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 3] HR Reporting</literalValue>
        <name>Update Adhoc Request Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Sent_To_GC</fullName>
        <description>This field update updates the check box after a mail has been sent to GC to avoid resending.</description>
        <field>SHP_GC_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>SHP Update Email Sent To GC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Number_Of_Times_Exempt_To_Non_Exe</fullName>
        <description>This Field Updates the counter for Number of times a request is converted from Exempt to Non Exempt.</description>
        <field>Number_Converted_From_Exempt_To_Non_Exem__c</field>
        <formula>Number_Converted_From_Exempt_To_Non_Exem__c +1</formula>
        <name>Update Number Of Times Exempt To Non Exe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Not_Found_Field_to_False</fullName>
        <description>To updated the field to unchecked.</description>
        <field>Provider_Not_Found__c</field>
        <literalValue>0</literalValue>
        <name>Update Provider Not Found Field to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Not_Found_Field_to_True</fullName>
        <field>Provider_Not_Found__c</field>
        <literalValue>1</literalValue>
        <name>Update Provider Not Found Field to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Requester_Name_on_SR</fullName>
        <description>Update the Requester Name on the S3 SR with the Parent Case Requester Name</description>
        <field>Requestor_Name__c</field>
        <formula>Parent_Case_Requester_Name__c</formula>
        <name>Update Requester Name on SR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Request_Created_to_No</fullName>
        <description>Update Service Request Created?  to No if Parent account number = o (blank)</description>
        <field>Service_Request_Created__c</field>
        <literalValue>No</literalValue>
        <name>Update Service Request Created to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_2</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_3</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_4</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_Portal</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_Provider</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag Provider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Flag_SHP</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Flag SHP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Value_to_Tier1_HR_Benefits</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 1] HR Benefits</literalValue>
        <name>Update Team Value to Tier1 HR Benefits</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Value_to_Tier1_HR_Perf_Mgmt</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 1] HR Performance Mgmt/ Learning/ Workforce</literalValue>
        <name>Update Team Value to Tier1 HR Perf Mgmt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Value_to_Tier1_Payroll</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 1] Payroll T&amp;E / Compensation</literalValue>
        <name>Update Team Value to Tier1 Payroll</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Value_to_Tier1_Recruitment</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 1] HR Recruitment</literalValue>
        <name>Update Team Value to Tier1 Recruitment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Team_Value_to_Tier3_HR_Reporting</fullName>
        <field>Team__c</field>
        <literalValue>[Tier 3] HR Reporting</literalValue>
        <name>Update Team Value to Tier3 HR Reporting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Field_to_False</fullName>
        <field>Bypass_ValidationRule__c</field>
        <literalValue>0</literalValue>
        <name>Updating Field to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%5BTier 3%5D Privacy Email Alert</fullName>
        <actions>
            <name>Tier_3_Privacy_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>[Tier 3] Privacy</value>
        </criteriaItems>
        <description>[Tier 3] Privacy Email Alert</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Adhoc Report Update</fullName>
        <actions>
            <name>Update_Adhoc_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Adhoc_Request_Customer_Intent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Adhoc_Request_Customer_Sub_Intent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Adhoc_Request_Sub_function</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Adhoc_Request_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Adhoc_Request_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Human Resources Adhoc Reports</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign to Onboarding Queue</fullName>
        <actions>
            <name>Assign_to_Onboarding_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP MSR Onboarding</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>COC Request Recordtype Change on Closed Status</fullName>
        <actions>
            <name>COC_Request_Recordtyp_to_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>COC Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>startsWith</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>The workflow changes the recordtype of the Case if the record&apos;s status is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case01_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case01_UpdateOwnerToPayroll</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_Payroll</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 Payroll T&amp;E / Compensation</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;Payroll&quot;), OR( ISPICKVAL( Inquiry_Reason__c , &quot;Employee Data Setup and Maintenance&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Employee Payroll or Paycheck Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Manager Payroll or Paycheck Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Timecard/Kronos Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Travel &amp; Expense Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Time Off Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Garnishment&quot;) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case02_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case02_UpdateOwnerToBenefits</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_HR_Benefits</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 Benefits</description>
        <formula>AND(  ISPICKVAL( Inquiry_Type__c , &quot;HR Benefits&quot;),  OR(  ISPICKVAL( Inquiry_Reason__c , &quot;ESL/Sick&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Health &amp; Welfare&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Health &amp; Welfare - FSA&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Health &amp; Welfare - Open Enrollment&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Other Benefits&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;PTO/Vacation&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Retiree Medical (RHCA, ERMA and Post-65)&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Retirement - Defined Contribution&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Retirement - Pension&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Retirement - General Inquiry&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Tuition/Education Reimbursement&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Wellness Program&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Work/Life Event&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Health &amp; Welfare - Premium Billing&quot;) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case03_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case03_UpdateOwnerTo_Tier1_HRPerformance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_HR_Perf_Mgmt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 HR Performance Mgmt/ Learning/ Workforce</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;HR General Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;HR Tool User Support&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case04_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case04_UpdateOwnerTo_Tier1_PerfLearnWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_HR_Perf_Mgmt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 HR Performance Mgmt/Learning/Workforce</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;HR General Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Employee Data Setup and Change&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case05_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case05_UpdateOwnerTo_Tier3_HRReporting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier3_HR_Reporting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to [Tier 3] HR Reporting</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;HR General Inquiry&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;HR Reporting&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case06_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case06_UpdateOwnerTo_Tier1_HRPerformance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_HR_Perf_Mgmt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 HR Performance Mgmt/ Learning/ Workforce</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;HR General Inquiry&quot;), OR(  ISPICKVAL( Inquiry_Reason__c , &quot;Employment &amp; Salary Verification&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;General Inquiry - HR&quot;) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case07_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case07_UpdateOwnerTo_Tier1_HRPerformance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_HR_Perf_Mgmt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 HR Performance Mgmt/ Learning/ Workforce</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;Performance/Learning&quot;), OR(  ISPICKVAL( Inquiry_Reason__c , &quot;Employee Learning&quot;),  ISPICKVAL( Inquiry_Reason__c , &quot;Employee Engagement&quot;) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case08_AssignOwnerToQueue</fullName>
        <actions>
            <name>Case08_UpdateOwnerTo_Tier1_HRRecruitment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Team_Value_to_Tier1_Recruitment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Case to Tier 1 HR Recruitment</description>
        <formula>AND( ISPICKVAL( Inquiry_Type__c , &quot;Recruitment&quot;), ISPICKVAL( Inquiry_Reason__c , &quot;Recruitment&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - Breaches</fullName>
        <actions>
            <name>Credentialing_Verification_Breaches</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Breaches</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Management&quot; Group when a CV case status is set to Re-assign.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - Closed</fullName>
        <actions>
            <name>Credentialing_Verification_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <description>This workflow sends a notification to the Customer Group when a CV case status is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - Escalation</fullName>
        <actions>
            <name>Credentialing_Verification_Escalation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Management&quot; Group when a CV case status is set to Re-assign.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - External Transfer</fullName>
        <actions>
            <name>Credentialing_Verification_External_Transfer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>External Transfer</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Management&quot; Group when a CV case status is set to external transfer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - New</fullName>
        <actions>
            <name>Credentialing_Verification_New</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification,CV - Address Change Request,CV - Affiliate Data Change Request,CV - Application Request,CV - Data Change Request,CV - Expirables Request,CV - Other Request,CV - Reapplication Request,CV - Report Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CV - Rush Application Request,CV - Temporary Privilege Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;Customer&quot; Group when a CV case status is created.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - On-Hold</fullName>
        <actions>
            <name>Credentialing_Verification_On_Hold</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Management&quot; Group when a CV case status is set to on-hold.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - Pending</fullName>
        <actions>
            <name>Credentialing_Verification_Pending</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Management&quot; Group when a CV case status is set to pending.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credentialing Verification - Re-Assign</fullName>
        <actions>
            <name>Credentialing_Verification_Re_assign</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credentialing Verification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-assign</value>
        </criteriaItems>
        <description>This workflow sends a notification to the &quot;S3 CV Tier 3&quot; Group when a CV case status is set to Re-assign.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DMC Email Notification</fullName>
        <actions>
            <name>DMC_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center,Document Management Center RO</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DMC Service Request Status Change - Closed</fullName>
        <actions>
            <name>DMC_Service_Request_Status_Change_Closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center,Document Management Center RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DMC Service Request Status Change - In Progress</fullName>
        <actions>
            <name>DMC_Service_Request_Status_Change_In_Progress</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center,Document Management Center RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DMC Service Request Status Change - New</fullName>
        <actions>
            <name>DMC_Service_Request_Status_Change_New</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center,Document Management Center RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DMC Service Request Status Change - On Hold</fullName>
        <actions>
            <name>DMC_Service_Request_Status_Change_On_Hold</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center,Document Management Center RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for Exempt Grieviance</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>Grievance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>equals</operation>
            <value>Member Grievance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Reason__c</field>
            <operation>equals</operation>
            <value>Exempt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Email Notification for Exempt Grieviance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_to_Agent_for_Exempt_Grievance</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>18</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Notification to A%26G on SR Completion</fullName>
        <actions>
            <name>Email_Notification_when_SR_is_completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Secondary_Reason__c,&apos;Grievance&apos;), OR(ISPICKVAL(Status, &apos;Closed&apos;),ISPICKVAL(Status, &apos;Resolved&apos;),ISPICKVAL(Status, &apos;Ready for Callback&apos;)), ISCHANGED(Status),OR( ISPICKVAL(PRIORVALUE(Status),&apos;In Progress&apos;), ISPICKVAL(PRIORVALUE(Status),&apos;New&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification to Case Originator</fullName>
        <actions>
            <name>Email_Notification_to_Case_Originator_After_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Benefits,Benefits RO,Billing,Billing RO,Claim Review,Claim Review RO,Clinical Notifications,Clinical Notifications RO,Complaint,Complaint RO,Correspondence,Correspondence RO,Documentation,Eligibility,Enrollment,Grievance,Member Experience</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Non-SHP Contact,OOA/OON,Portal Questions,Provider Dispute,SHP Interaction Log</value>
        </criteriaItems>
        <description>To Notify User who Initiated the High Priority SR when it is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notification for SHP Member Services Portal Request</fullName>
        <actions>
            <name>Email_notification_sent_when_SRs_are_routed_to_SHP_Member_Services_Portal_Reques</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP ATC Eligibility Related</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP ATC Plan Change Issue Related</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP Billing Invoice Question</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP Update Request for Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordType_Name__c</field>
            <operation>equals</operation>
            <value>SHP Update Request for Contact</value>
        </criteriaItems>
        <description>Email notification sent when SR are routed to SHP Member Services Portal Request queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Escalated Checkbox</fullName>
        <actions>
            <name>Escalated_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>When status = Escalated, isEscalated checkbox = true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Grievance Exempt Email</fullName>
        <actions>
            <name>Grievance_Email_SR_Changed_to_Exempt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When grievance is changed to exempt and case assigned to the exempt queue, 
email notification is sent to person who created the exempt grievance and cc managers (Connie and Jason)</description>
        <formula>AND(  RecordType.Name = &apos;Grievance&apos;,   NOT(OR( ISPICKVAL( Reason__c , &apos;DMHC Additional Information&apos;) , ISPICKVAL( Reason__c , &apos;DMHC Notification&apos;))),OR(    ISPICKVAL(PRIORVALUE(Secondary_Reason__c) ,&apos;Routine&apos;),    ISPICKVAL(PRIORVALUE(Secondary_Reason__c) ,&apos;Expedited&apos;)), ISPICKVAL(Secondary_Reason__c,&apos;Exempt&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Grievance NonExempt Email</fullName>
        <actions>
            <name>Grievance_Email_SR_Changed_to_NonExempt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When grievance is changed to nonexempt and case assigned to the nonexempt queue, 
email notification is sent to person who created the grievance and cc managers (Connie and Jason) and GC.</description>
        <formula>AND(  RecordType.Name = &apos;Grievance&apos;,  NOT(OR( ISPICKVAL( Reason__c , &apos;DMHC Additional Information&apos;) , ISPICKVAL( Reason__c , &apos;DMHC Notification&apos;))), OR(    ISPICKVAL(Secondary_Reason__c ,&apos;Routine&apos;),    ISPICKVAL(Secondary_Reason__c ,&apos;Expedited&apos;)), ISPICKVAL(PRIORVALUE(Secondary_Reason__c),&apos;Exempt&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Human Resource Web To Case RO</fullName>
        <actions>
            <name>Human_Resource_Web_To_Case_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Human Resource Web To Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updated the Human resource Web To Case To RO on update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MU Team Closed An Escalated Case</fullName>
        <actions>
            <name>MU_Escalation_Closed_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Status,&apos;Closed&apos;) &amp;&amp;  ISPICKVAL(PRIORVALUE(Status),&apos;Escalate To Meaningful Use&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Non-Sutter Email to Case</fullName>
        <actions>
            <name>Clear_Comment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Non_Sutter_Email_to_case__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>On Hold Restart</fullName>
        <actions>
            <name>Case_Stopped_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a Case with a status of On Hold is changed to a Status which is not On Hold and not Closed, change the Case Stopped field to false, thus restarting the Milestone timers</description>
        <formula>AND (ISPICKVAL(PRIORVALUE(Status), &quot;On Hold&quot;), NOT(ISPICKVAL(Status, &quot;On Hold&quot;)), NOT( IsClosed ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>On Hold Stop</fullName>
        <actions>
            <name>Milestone_Stopped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>Stops Milestone Clocks when status is set to On Hold</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PDR - Send Determination Letter</fullName>
        <actions>
            <name>PDR_Determination_not_set</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Determination_set_by_milestone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Determination__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send the determination letter when the determination letter milestone is completed (success or violation), which is determined from the field Determination set by milestone</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Provider Directory Inaccuracy RO</fullName>
        <actions>
            <name>Provider_Directory_Inaccuracy_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Provider Directory Inaccuracy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reset bypass checkbox</fullName>
        <actions>
            <name>Reset_bypass_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Bypass_Validation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Address Change Request RO</fullName>
        <actions>
            <name>Address_Change_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Address Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Address Change Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Affiliate Data Change Request RO</fullName>
        <actions>
            <name>Affiliate_Data_Change_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Affiliate Data Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Affiliate Data Change Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Application Request RO</fullName>
        <actions>
            <name>Application_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Application Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Data Change Request RO</fullName>
        <actions>
            <name>Data_Change_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Data Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Data Change Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Document Management Center RO</fullName>
        <actions>
            <name>Document_Management_Center_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Document Management Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Change Document Management Center record type to Document Management Center RO when Status is Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Email Notification to Employee Customer Service Request is New</fullName>
        <actions>
            <name>Employee_Inquiry_New</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Email Notification to Employee Customer: New</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>S3 Email Notification to Vendor Customer Service Request is New</fullName>
        <actions>
            <name>Vendor_Email_Notification_New</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Accounting,Finance Accounting RO,Finance Accounts Payable,Finance Accounts Payable RO,Finance Payroll,Finance Payroll RO,Human Resources,Revenue Cycle RO,Revenue Cycle,Supply Chain,Supply Chain RO,Human Resources RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Email Notification to Vendor Customer: New</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>S3 Employee Inquiry Portal Closed Comments</fullName>
        <actions>
            <name>Employee_Portal_Closed_Inquiry_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee Inquiry,Employee Inquiry RO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Employee Inquiry Portal Closed Comments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Employee Inquiry RO</fullName>
        <actions>
            <name>S3_Employee_Inquiry_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Employee Inquiry to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Expirables Request RO</fullName>
        <actions>
            <name>Expirables_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Expirables Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Expirables Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Finance Accounting RO</fullName>
        <actions>
            <name>Finance_Accounting_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Finance Accounting to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Finance Accounts Payable RO</fullName>
        <actions>
            <name>Finance_Accounts_Payable_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Accounts Payable</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Finance Accounts Payable to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Finance Payroll RO</fullName>
        <actions>
            <name>Finance_Payroll_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Payroll</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Finance Payroll to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Human Resources RO</fullName>
        <actions>
            <name>Human_Resources_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Human Resources</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Human Resources to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Interaction Log RO</fullName>
        <actions>
            <name>S3_IL_to_RO_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>S3 Interaction Log</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Interaction Log to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Interaction Log to Patient Interaction Log</fullName>
        <actions>
            <name>S3_IL_to_Patient_Interaction_Log</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>S3 Interaction Log</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Function__c</field>
            <operation>equals</operation>
            <value>Revenue Cycle</value>
        </criteriaItems>
        <description>Converts S3 Interaction Log to S3 Patient Interaction Log</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Other Request RO</fullName>
        <actions>
            <name>Other_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Other Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Other Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Patient Interaction Log RO</fullName>
        <actions>
            <name>S3_Patient_Interaction_Log_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>S3 Patient Interaction Log</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Patient Interaction Log to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Reapplication Request RO</fullName>
        <actions>
            <name>Reapplication_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Reapplication Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Reapplication Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Report Request RO</fullName>
        <actions>
            <name>Report_Request_Change_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Report Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Report Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Revenue Cycle RO</fullName>
        <actions>
            <name>S3_Revenue_Cycle_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Revenue Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Revenue Cycle to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Rush Application Request RO</fullName>
        <actions>
            <name>Rush_Application_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Rush Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Rush Application Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Supply Chain RO</fullName>
        <actions>
            <name>S3_Supply_Chain_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Supply Chain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Supply Chain to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>S3 Temporary Privilege Request RO</fullName>
        <actions>
            <name>Temporary_Privilege_Request_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Temporary Privilege Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set S3 Temporary Privilege Request to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP - Claim Not Reprocessed</fullName>
        <actions>
            <name>Call_Back_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Member_Services_Call_Back</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Not_Reprocessed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Not Reprocessed</value>
        </criteriaItems>
        <description>Workflow for when a claim is not reprocessed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Benefits RO</fullName>
        <actions>
            <name>SHP_Benefits_SR_to_RT_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Benefits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Benefits to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Billing RO</fullName>
        <actions>
            <name>SHP_Closed_Billing_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Billing to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Call Back Routing</fullName>
        <actions>
            <name>Call_Back_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Member_Services_Call_Back</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Ready for Call Back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Provider Dispute,Claim Review,Grievance,Non-SHP Contact,Benefits,Documentation,Complaint,Enrollment,Billing,Eligibility</value>
        </criteriaItems>
        <description>This workflow is designed to route a service request to the work queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Claim Review RO</fullName>
        <actions>
            <name>Claim_Review_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Claim Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Claim Review to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Clinical Notifications RO</fullName>
        <actions>
            <name>SHP_Clinical_Notifications_SR_to_RT_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Clinical Notifications</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Clinical Notifications to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Complaint RO</fullName>
        <actions>
            <name>SHP_Complaint_RT_to_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Complaint to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Correspondence RO</fullName>
        <actions>
            <name>SHP_Correspondence_RO_Filed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Correspondence</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Documentation RO</fullName>
        <actions>
            <name>SHP_Documentation_RT_to_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Documentation to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Eligibility RO</fullName>
        <actions>
            <name>SHP_Closed_Eligibility_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Eligibility</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Eligibility to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Email Alert on Change to Call Back Queue</fullName>
        <actions>
            <name>SHP_Email_Alert_Call_Back</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Email alert on change Owner to Queue SHP Member Service &quot;Call Back&quot;</description>
        <formula>AND(IsChanged(OwnerId),OwnerId = $Label.SHP_Member_Service_Call_Back ,OR(RecordType.Name = &apos;Provider Dispute&apos;, RecordType.Name = &apos;Non-SHP Contact&apos;, RecordType.Name = &apos;Benefits&apos;,  RecordType.Name = &apos;Portal Questions&apos;, RecordType.Name = &apos;Clinical Notifications&apos;, RecordType.Name = &apos;Documentation&apos;,  RecordType.Name = &apos;Eligibility&apos;, RecordType.Name = &apos;Complaint&apos;, RecordType.Name = &apos;Claim Review&apos;,  RecordType.Name = &apos;Billing&apos;, RecordType.Name = &apos;Enrollment&apos;), NOT(IsChanged(Status)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Enrollment RO</fullName>
        <actions>
            <name>SHP_Closed_Enrollment_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Enrollment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Eligibility to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Grievance Non-Exempt SR is created</fullName>
        <actions>
            <name>SHP_Grievance_when_Non_Exempt_SR_is_created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent_To_GC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5 AND 8) OR (4 AND 6 AND 7 AND 8)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grievance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Reason__c</field>
            <operation>equals</operation>
            <value>Expedited,Routine</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SHP_GC_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Reason__c</field>
            <operation>equals</operation>
            <value>Routine</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>notEqual</operation>
            <value>DMHC Additional Information,DMHC Notification</value>
        </criteriaItems>
        <description>Req. 3200 (Release 6.1)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SHP Grievance RO</fullName>
        <actions>
            <name>Grievance_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grievance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Grievance to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Grievance SR task creation</fullName>
        <actions>
            <name>Send_Acknowledgement_Letter</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Service_Grievance Service Request_Case_RT</value>
        </criteriaItems>
        <description>Once the Grievance Service Request is completed, a letter of determination will be sent to the submitter</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Grievance converted from Exempt to non-Exempt</fullName>
        <actions>
            <name>Converted_From_Exempt_To_Non_Exempt</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Number_Of_Times_Exempt_To_Non_Exe</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Req 3200 Release 6.1</description>
        <formula>AND(  RecordType.Name = &apos;Grievance&apos;,   ISPICKVAL(PRIORVALUE(Secondary_Reason__c) ,&apos;Exempt&apos;), OR(  ISPICKVAL(Secondary_Reason__c,&apos;Routine&apos;),  ISPICKVAL(Secondary_Reason__c,&apos;Expedited&apos;)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Grievance converted from non-Exempt to Exempt</fullName>
        <actions>
            <name>Converted_From_Non_Exempt_To_Exempt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Req 3200 Release 6.1</description>
        <formula>AND(  RecordType.Name = &apos;Grievance&apos;, OR(    ISPICKVAL(PRIORVALUE(Secondary_Reason__c) ,&apos;Routine&apos;),    ISPICKVAL(PRIORVALUE(Secondary_Reason__c) ,&apos;Expedited&apos;)), ISPICKVAL(Secondary_Reason__c,&apos;Exempt&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Interaction Log RO</fullName>
        <actions>
            <name>SHP_IL_to_RO_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Service_Interaction Log_Case_RT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Interaction Log to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Legal%2FMedia Threat Communication Team</fullName>
        <actions>
            <name>SHP_Mail_on_Communication_Team_Media_Legal_Threat</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL( Reason__c , &apos;Public Action&apos;), OR( ISPICKVAL(Secondary_Reason__c,&apos;Media Threat&apos;), ISPICKVAL(Secondary_Reason__c,&apos;Legal Threat&apos;)),  IsThreatEMailSent__c == true,  OR(ISCHANGED(Secondary_Reason__c),ISCHANGED(IsThreatEMailSent__c))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SHP Letter of Determination Task</fullName>
        <actions>
            <name>Send_Letter_of_Determination</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Service_Grievance Service Request_Case_RT</value>
        </criteriaItems>
        <description>Once the Grievance Service Request is completed, a letter of determination will be sent to the submitter</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Member Experience RO</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Member Experience</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Member Experience to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Non-SHP RO</fullName>
        <actions>
            <name>Non_SHP_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Non-SHP Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Non-SHP to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP OOA%2FOON RO</fullName>
        <actions>
            <name>OOA_OON_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>OOA/OON</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Set SHP OOA/OON to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Portal Questions RO</fullName>
        <actions>
            <name>SHP_Portal_Questions_SR_to_RT_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Portal Questions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Portal Questions to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Provider Dispute RO</fullName>
        <actions>
            <name>Provider_Dispute_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Provider Dispute</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set SHP Provider Dispute to RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SHP Web Grievance Expedited SR is created</fullName>
        <actions>
            <name>SHP_Web_Grievance_when_Expedited_SR_is_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grievance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Secondary_Reason__c</field>
            <operation>equals</operation>
            <value>Expedited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SHP_GC_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <description>Req. 3200 (Release 6.1)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email alert to Owner after 5 days for SHP</fullName>
        <active>true</active>
        <formula>AND( NOT(BEGINS(OwnerId ,&apos;00G&apos;)),  OR(CONTAINS(RecordType_Name__c ,&apos;Benefits&apos;) ,CONTAINS(RecordType_Name__c ,&apos;Billing&apos;),CONTAINS(RecordType_Name__c ,&apos;Complaint&apos;),  CONTAINS(RecordType_Name__c ,&apos;Documentation&apos;) , CONTAINS(RecordType_Name__c ,&apos;Eligibility&apos;) , CONTAINS(RecordType_Name__c ,&apos;Enrollment&apos;),  CONTAINS(RecordType_Name__c ,&apos;Non-SHP Contact&apos;), CONTAINS(RecordType_Name__c ,&apos;Portal Inquiry&apos;) , CONTAINS(RecordType_Name__c ,&apos;Claim Review&apos;),  CONTAINS(RecordType_Name__c ,&apos;Grievance&apos;) , CONTAINS(RecordType_Name__c ,&apos;Provider Dispute&apos;),  CONTAINS(RecordType_Name__c ,&apos;Clinical Notifications&apos;), CONTAINS(RecordType_Name__c ,&apos;Portal Questions&apos;) , CONTAINS(RecordType_Name__c ,&apos;Member Experience&apos;),  CONTAINS(RecordType_Name__c ,&apos;Correspondence&apos;), CONTAINS(RecordType_Name__c ,&apos;OOA/OON&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP ATC Eligibility Related&apos;),  CONTAINS(RecordType_Name__c ,&apos;SHP ATC Plan Change Issue Related&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP Billing Invoice Question&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP Broker Education&apos;),  CONTAINS(RecordType_Name__c ,&apos;SHP EDI Escalated Issue&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP EDI Feed Issue&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP EDI Issue Member in WB&apos;),  CONTAINS(RecordType_Name__c ,&apos;SHP Employer Education&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP Employer Portal Approval Access Inquiries&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP Member Information Request Related&apos;),  CONTAINS(RecordType_Name__c ,&apos;SHP RFP Rejection Related&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP SCN Submission Rejection Related&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP Update Request for Accounts&apos;),  CONTAINS(RecordType_Name__c ,&apos;SHP Update Request for Contact&apos;),CONTAINS(RecordType_Name__c ,&apos;Update Request for Accounts&apos;),CONTAINS(RecordType_Name__c ,&apos;SHP ATC Incomplete Submission Related&apos;)  ),  ISPICKVAL(Priority, &apos;High&apos;),  IsClosed = false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SHP_Alert_to_SR_Owner_after_5_days_from_Created_Date_with_time_trigger</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Survey Request for a S3 IL sent to Contact</fullName>
        <actions>
            <name>Survey_Email_to_S3_IL_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_IL__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SR_Associated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Revenue Cycle RO,S3 Patient Interaction Log,S3 Patient Interaction Log RO,Revenue Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Origin_Survey__c</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Move to Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Function__c</field>
            <operation>notEqual</operation>
            <value>GL Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Intent__c</field>
            <operation>notEqual</operation>
            <value>Dropped Call,Wrong Number</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Business Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inquiry_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Call Abandoned,System Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Transferred_Reason__c</field>
            <operation>notEqual</operation>
            <value>Wrong Department</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Unresolved_Reason__c</field>
            <operation>notEqual</operation>
            <value>Outbound Attempt</value>
        </criteriaItems>
        <description>Workflow Rule for sending a Survey Request for a S3 IL to the IL Contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a S3 IL sent to Requester</fullName>
        <actions>
            <name>Survey_Email_to_S3_IL_Requester</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_IL__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Requestor_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SR_Associated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Revenue Cycle RO,S3 Patient Interaction Log,S3 Patient Interaction Log RO,Revenue Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Origin_Survey__c</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Move to Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Function__c</field>
            <operation>notEqual</operation>
            <value>GL Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Intent__c</field>
            <operation>notEqual</operation>
            <value>Dropped Call,Wrong Number</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Business Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inquiry_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Call Abandoned,System Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Transferred_Reason__c</field>
            <operation>notEqual</operation>
            <value>Wrong Department</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Unresolved_Reason__c</field>
            <operation>notEqual</operation>
            <value>Outbound Attempt</value>
        </criteriaItems>
        <description>Workflow Rule for sending a Survey Request for a S3 IL to the IL Requester</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a S3 SR sent to Contact</fullName>
        <actions>
            <name>CSAT_Survey_Request_for_S3_SR_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 AND 15</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_SR__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Revenue Cycle RO,S3 Patient Interaction Log,S3 Patient Interaction Log RO,Revenue Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Origin_Survey__c</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Move to Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Function__c</field>
            <operation>notEqual</operation>
            <value>GL Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Executive_Service__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Referred_to_Region__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Duplicate,Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Intent__c</field>
            <operation>notEqual</operation>
            <value>Dropped Call,Wrong Number</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Business Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inquiry_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Call Abandoned,System Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Transferred_Reason__c</field>
            <operation>notEqual</operation>
            <value>Wrong Department</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Unresolved_Reason__c</field>
            <operation>notEqual</operation>
            <value>Outbound Attempt</value>
        </criteriaItems>
        <description>Workflow Rule for sending a Survey Request for a S3 SR to the SR Contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a S3 SR sent to Requester</fullName>
        <actions>
            <name>Survey_Email_S3_SR_Requester</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 AND 15</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_SR__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Parent_Case_Requester_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Revenue Cycle RO,S3 Patient Interaction Log,S3 Patient Interaction Log RO,Revenue Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Origin_Survey__c</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Move to Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Function__c</field>
            <operation>notEqual</operation>
            <value>GL Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Referred_to_Region__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Close_Reason__c</field>
            <operation>notEqual</operation>
            <value>Cancelled,Duplicate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Intent__c</field>
            <operation>notEqual</operation>
            <value>Dropped Call,Wrong Number</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Business Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inquiry_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Call Abandoned,System Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Transferred_Reason__c</field>
            <operation>notEqual</operation>
            <value>Wrong Department</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Unresolved_Reason__c</field>
            <operation>notEqual</operation>
            <value>Outbound Attempt</value>
        </criteriaItems>
        <description>Workflow Rule for sending a Survey Request for a S3 SR to the SR Requester</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Survey Request for a SHP IL sent to Contact</fullName>
        <actions>
            <name>Survey_Email_to_SHP_IL_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_SHP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>notEqual</operation>
            <value>Portal,Portal Questions,Provider,Provider Directory request,Provider Dispute,Provider Dispute Level 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.SHP_Turn_off_Surveys__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Provider</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a SHP IL sent to Portal</fullName>
        <actions>
            <name>Survey_Email_to_SHP_IL_Contact_Portal</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_Portal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>equals</operation>
            <value>Portal,Portal Questions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.SHP_Turn_off_Surveys__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Provider</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey Request for a SHP IL sent to Provider</fullName>
        <actions>
            <name>Survey_Email_to_SHP_IL_Provider</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Flag_Provider</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>contains</operation>
            <value>Provider,Provider Directory request,Provider Dispute,Provider Dispute Level 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.SHP_Turn_off_Surveys__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SHP Provider</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Training Request RO</fullName>
        <actions>
            <name>Training_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Training</value>
        </criteriaItems>
        <description>Set Training Request RO recordtype</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Bypass Validation to false</fullName>
        <actions>
            <name>Updating_Field_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Bypass_ValidationRule__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Requester Email on SR</fullName>
        <actions>
            <name>Case_Requester_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_SR__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Workflow Rule to update the Requester Email Address on the Service Request. The updated Requester Email Address will be used for sending a Survey Request</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Requester Name on SR</fullName>
        <actions>
            <name>Update_Requester_Name_on_SR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.S3_SR__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Workflow rule to update the Case Requester Name field on a S3 SR when the SR is closed. The field will be updated with the Parent Case Requester Name. This is needed for use in the Email template &apos;CSAT Survey Email to Requester&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Provider Not Found to False</fullName>
        <actions>
            <name>Update_Provider_Not_Found_Field_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Other_Provider__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>To uncheck the Provider Not Found checkbox when Other Provider is deleted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Provider Not Found to True</fullName>
        <actions>
            <name>Update_Provider_Not_Found_Field_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Other_Provider__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Was Service Request Created on IL</fullName>
        <actions>
            <name>Service_Request_Created_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>Reporting field update. Flags a field if the Parent Case # is 0 to allow reporting on IL that created SR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Was Service Request Created on IL - No</fullName>
        <actions>
            <name>Update_Service_Request_Created_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Reporting field update. Flags a field if the Parent Case # is 0 to allow reporting on IL that created SR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Send_Acknowledgement_Letter</fullName>
        <assignedToType>creator</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Acknowledgement Letter</subject>
    </tasks>
    <tasks>
        <fullName>Send_Letter_of_Determination</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Letter of Determination</subject>
    </tasks>
</Workflow>
