<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Owner_To_VP_Marketing</fullName>
        <field>OwnerId</field>
        <lookupValue>VP_Marketing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner To VP Marketing</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_toSales_marketing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Sales_Marketing_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to Sales &amp; marketing Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Marketing</fullName>
        <field>OwnerId</field>
        <lookupValue>Marketing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to Marketing</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_VP_Sales</fullName>
        <field>OwnerId</field>
        <lookupValue>VP_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to VP Sales</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_To_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_VP_Marketing</fullName>
        <field>Status__c</field>
        <literalValue>VP Marketing review</literalValue>
        <name>Status to VP Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_VP_Sales</fullName>
        <field>Status__c</field>
        <literalValue>VP Sales review</literalValue>
        <name>Status to VP Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_VP_Sales_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>VP Sales Rejected</literalValue>
        <name>Status to VP Sales Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VP_Marketing_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>VP Marketing Rejected</literalValue>
        <name>VP Marketing Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
