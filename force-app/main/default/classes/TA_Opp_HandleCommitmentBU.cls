public with sharing class TA_Opp_HandleCommitmentBU implements TriggerAction.BeforeUpdate {

    public void beforeUpdate(
        List<Opportunity> newList, 
        List<Opportunity> oldList
    ) {
        Map<String, String> mapStageToState = fsl_JournalEntryService.getStageToStateMappings();
        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>(oldList);
        for (Opportunity opp : newList) {
            String newState = mapStageToState.containsKey(opp.StageName)
                ? mapStageToState.get(opp.StageName)
                : fsl_Constants.ACCOUNTING_STATE_UNCOMMITTED;
            String oldState = mapStageToState.containsKey(oldMap.get(opp.Id).StageName) 
                ? mapStageToState.get(oldMap.get(opp.Id).StageName) 
                : fsl_Constants.ACCOUNTING_STATE_UNCOMMITTED;
            if (
                (newState == fsl_Constants.ACCOUNTING_STATE_COMMITTED || 
                newState == fsl_Constants.ACCOUNTING_STATE_FINALIZED) &&
                oldState == fsl_Constants.ACCOUNTING_STATE_UNCOMMITTED
            ) {
                opp.Committed_Date__c = opp.CloseDate <= System.today() ? opp.CloseDate : System.today();
            }
        }
    }
    
}