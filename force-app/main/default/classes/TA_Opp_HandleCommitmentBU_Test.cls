@isTest
private class TA_Opp_HandleCommitmentBU_Test {
    
    @isTest
    static void testUpdateStageToCommitted() {
        npsp__General_Accounting_Unit__c gau = fsl_TestDataFactory.createGeneralAccountingUnits(1).get(0);
        insert gau;

        Contact ct = fsl_TestDataFactory.createContacts(1).get(0);
        insert ct;

        // Insert single opportunity in an uncommitted accounting state
        Opportunity opp = fsl_TestDataFactory.createOpportunity(ct, 1000, fsl_Constants.ACCOUNTING_STATE_UNCOMMITTED);
        insert opp;

        Test.startTest();
        // Update to committed accounting state
        opp.StageName = fsl_TestDataFactory.getOppStageFromAccState(fsl_Constants.ACCOUNTING_STATE_COMMITTED);
        Database.SaveResult sr = Database.update(opp);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'Should have successfully updated committed opp');

        Opportunity refreshedOpp = [SELECT Id, Committed_Date__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals(Date.today(), refreshedOpp.Committed_Date__c, 'Opportunity should have a committed date of today');
    }

    @isTest
    static void testUpdateStageToFinalized() {
        npsp__General_Accounting_Unit__c gau = fsl_TestDataFactory.createGeneralAccountingUnits(1).get(0);
        insert gau;

        Contact ct = fsl_TestDataFactory.createContacts(1).get(0);
        insert ct;

        // Insert single opportunity in an uncommitted accounting state
        Opportunity opp = fsl_TestDataFactory.createOpportunity(ct, 1000, fsl_Constants.ACCOUNTING_STATE_UNCOMMITTED);
        insert opp;

        Test.startTest();
        // Update to finalized accounting state
        opp.StageName = fsl_TestDataFactory.getOppStageFromAccState(fsl_Constants.ACCOUNTING_STATE_FINALIZED);
        Database.SaveResult sr = Database.update(opp);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'Should have successfully updated finalized opp');

        Opportunity refreshedOpp = [SELECT Id, Committed_Date__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals(Date.today(), refreshedOpp.Committed_Date__c, 'Opportunity should have a committed date of today');
    }

    @isTest
    static void testBogusStageNames() {
        npsp__General_Accounting_Unit__c gau = fsl_TestDataFactory.createGeneralAccountingUnits(1).get(0);
        insert gau;

        Contact ct = fsl_TestDataFactory.createContacts(1).get(0);
        insert ct;

        // Insert single opportunity in an uncommitted accounting state
        Opportunity opp = fsl_TestDataFactory.createOpportunity(ct, 1000, 'BogusStage');
        insert opp;

        Test.startTest();
        // Update to committed accounting state
        opp.StageName = 'MoBogusStage';
        Database.SaveResult sr = Database.update(opp);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'Should have successfully updated committed opp');

        Opportunity refreshedOpp = [SELECT Id, Committed_Date__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals(null, refreshedOpp.Committed_Date__c, 'Opportunity should not have a committed date');
    }
    
}