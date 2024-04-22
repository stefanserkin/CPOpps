@isTest
private class TA_Opp_HandleCommitmentBI_Test {
    
    @isTest
    static void testInsertCommittedOpp() {
        npsp__General_Accounting_Unit__c gau = fsl_TestDataFactory.createGeneralAccountingUnits(1).get(0);
        insert gau;

        Contact ct = fsl_TestDataFactory.createContacts(1).get(0);
        insert ct;

        // Insert single opportunity in a committed accounting state
        Opportunity opp = fsl_TestDataFactory.createOpportunity(ct, 1000, fsl_Constants.ACCOUNTING_STATE_COMMITTED);
        Test.startTest();
        Database.SaveResult sr = Database.insert(opp);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'Should have successfully inserted committed opp');

        Opportunity refreshedOpp = [SELECT Id, Committed_Date__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals(Date.today(), refreshedOpp.Committed_Date__c, 'Opportunity should have a committed date of today');
    }

    @isTest
    static void testInsertFinalizedOpp() {
        npsp__General_Accounting_Unit__c gau = fsl_TestDataFactory.createGeneralAccountingUnits(1).get(0);
        insert gau;

        Contact ct = fsl_TestDataFactory.createContacts(1).get(0);
        insert ct;

        // Insert single opportunity in a committed accounting state
        Opportunity opp = fsl_TestDataFactory.createOpportunity(ct, 1000, fsl_Constants.ACCOUNTING_STATE_FINALIZED);
        Test.startTest();
        Database.SaveResult sr = Database.insert(opp);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'Should have successfully inserted committed opp');

        Opportunity refreshedOpp = [SELECT Id, Committed_Date__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals(Date.today(), refreshedOpp.Committed_Date__c, 'Opportunity should have a committed date of today');
    }

}