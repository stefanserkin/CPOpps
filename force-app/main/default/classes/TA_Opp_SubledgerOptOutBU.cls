public with sharing class TA_Opp_SubledgerOptOutBU implements TriggerAction.BeforeUpdate {
    
    private static Id cpRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
        .get('Community_Programs').getRecordTypeId();

    /**
     * Manage from sObject Trigger Setting: Opportunity
     */
    public void beforeUpdate(List<Opportunity> newList, List<Opportunity> oldList) {
        for (Opportunity opp : newList) {
            if (opp.RecordTypeId == cpRecordTypeId) {
                opp.Do_Not_Create_Journal_Entries__c = true;
            }
        }
    }

}