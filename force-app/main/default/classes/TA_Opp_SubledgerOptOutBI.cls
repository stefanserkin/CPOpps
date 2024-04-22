public with sharing class TA_Opp_SubledgerOptOutBI implements TriggerAction.BeforeInsert {

    private static Id cpRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
        .get('Community_Programs').getRecordTypeId();

    /**
     * Manage from sObject Trigger Setting: Opportunity
     */
    public void beforeInsert(List<Opportunity> newList) {
        for (Opportunity opp : newList) {
            if (opp.RecordTypeId == cpRecordTypeId) {
                opp.Do_Not_Create_Journal_Entries__c = true;
            }
        }
    }

}