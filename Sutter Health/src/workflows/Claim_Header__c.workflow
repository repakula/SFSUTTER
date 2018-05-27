<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateClaimMemberId</fullName>
        <field>ClaimMemberIdField__c</field>
        <formula>If(CONTAINS(If(CONTAINS(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),
SHPClaimHdr_Member_HCC_ID__c),&apos;-&apos;),SUBSTITUTE(If(CONTAINS(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),
SHPClaimHdr_Member_HCC_ID__c), &apos;-&apos;,&apos;&apos;),If(CONTAINS(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;),SUBSTITUTE(
SHPClaimHdr_Member_HCC_ID__c, &apos;M&apos;, &apos;&apos;),
SHPClaimHdr_Member_HCC_ID__c))</formula>
        <name>UpdateClaimMemberId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdateClaimMemberId</fullName>
        <actions>
            <name>UpdateClaimMemberId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Claim_Header__c.SHPClaimHdr_Member_HCC_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow updates the Member Id field on Claim Headers.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
