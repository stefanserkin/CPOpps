@IsTest
private class TA_Opp_SubledgerOptOut_Test {

    private static Id cpRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
        .get('Community_Programs').getRecordTypeId();
    
    @IsTest
    static void testSubledgerOptOutBI() {
        Opportunity opp = new Opportunity(
            RecordTypeId = cpRecordTypeId,
            Do_Not_Create_Journal_Entries__c = false
        );

        Test.startTest();
        TA_Opp_SubledgerOptOutBI ta = new TA_Opp_SubledgerOptOutBI();
        ta.beforeInsert(new List<Opportunity>{opp});
        Test.stopTest();

        Assert.isTrue(opp.Do_Not_Create_Journal_Entries__c, 'Opp should have been opted out of journal entry creation');
    }

    @IsTest
    static void testSubledgerOptOutBU() {
        List<Opportunity> newList = new List<Opportunity>();
        List<Opportunity> oldList = new List<Opportunity>();

        Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);

        newList.add( 
            new Opportunity(
                Id = oppId,
                RecordTypeId = cpRecordTypeId,
                Do_Not_Create_Journal_Entries__c = false
            )
        );
        oldList.add( 
            new Opportunity(
                Id = oppId,
                RecordTypeId = cpRecordTypeId,
                Do_Not_Create_Journal_Entries__c = false
            )
        );

        Test.startTest();
        new TA_Opp_SubledgerOptOutBU().beforeUpdate(newList, oldList);
        Test.stopTest();

        Assert.isTrue(newList[0].Do_Not_Create_Journal_Entries__c, 'Opp should have been opted out of journal entry creation');
    }

}