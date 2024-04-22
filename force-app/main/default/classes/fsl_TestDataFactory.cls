@isTest
public class fsl_TestDataFactory {
    
    /***********************************
     * Static Variables
     ***********************************/    

    private static Id householdRecordTypeId;
    private static Id organizationRecordTypeId;
    private static Map<String, List<String>> mapStateToStages;
    
    /***********************************
     * Constants
     ***********************************/

    // Accounts
	private static final String ACCOUNT_BASE_NAME = 'Wright Household';
    private static final String ORGANIZATION_BASE_NAME = 'Big Corp';
    // Affiliations
    private static final String AFFILIATION_STATUS_CURRENT = 'Current';
    private static final String AFFILIATION_STATUS_FORMER = 'Former';
    // Contacts
    private static final String CONTACT_BASE_FIRST_NAME = 'David';
    private static final String CONTACT_BASE_MIDDLE_NAME = 'Captain';
    private static final String CONTACT_BASE_LAST_NAME = 'Wright';
    private static final Date CONTACT_BASE_BIRTHDATE = Date.today().addYears(-21);
    // Groups
    private static final String PUBLIC_GROUP_NAME = 'Test Group Test';
    private static final String GROUP_TYPE_REGULAR = 'Regular';
    // Users
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';
    private static final String STANDARD_USER_USERNAME = 'standarduser' + DateTime.now().getTime() + '@agtests.com';
    private static final String STANDARD_USER_EMAIL = 'testing@testthings.com';
    private static final String STANDARD_USER_FIRSTNAME = 'Tester';
    private static final String STANDARD_USER_LASTNAME = 'Testerson';
    private static final String STANDARD_USER_ALIAS = 'tester';
    private static final String STANDARD_USER_NICKNAME = 'TestUser193948';
    private static final String STANDARD_USER_PROFILE_NAME = 'Standard User';


    /***********************************
     * Accounts
     ***********************************/

    /**
     * Create accounts with a household record type
     * No DML - returns unsaved list of sObjects
     * @param Integer Number of records to create
     */

    public static List<Account> createHouseholdAccounts(
        Integer numberOfHouseholds
    ) {
        List<Account> lstHouseholds = new List<Account>();
        if (householdRecordTypeId == null) {
            householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HH_Account').getRecordTypeId();
        }
        for (Integer i = 0; i < numberOfHouseholds; i++) {
            lstHouseholds.add( 
                new Account(
                    Name = ACCOUNT_BASE_NAME + String.valueOf(i), 
                    RecordTypeId = householdRecordTypeId
                )
            );
        }
        return lstHouseholds;
    }

    /**
     * Create accounts with an organization record type
     * No DML - returns unsaved list of sObjects
     * @param Integer Number of records to create
     */

    public static List<Account> createOrganizationAccounts(
        Integer numberOfOrganizations
    ) {
        List<Account> lstOrganizations = new List<Account>();
        if (organizationRecordTypeId == null) {
            organizationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organization').getRecordTypeId();
        }
        for (Integer i = 0; i < numberOfOrganizations; i++) {
            lstOrganizations.add( 
                new Account(
                    Name = ORGANIZATION_BASE_NAME + String.valueOf(i), 
                    RecordTypeId = organizationRecordTypeId
                )
            );
        }
        return lstOrganizations;
    }


    /***********************************
     * Accounting Period (fsl)
     ***********************************/

    /**
     * Create open accounting period
     * No DML - returns a single, unsaved sObject
     */

     public static Accounting_Period__c createOpenAccountingPeriod() {
        Date startDate = Date.newInstance(Date.today().year(), Date.today().month(), 1);
        Date endDate = startDate.addMonths(1).addDays(-1);
        Accounting_Period__c ap = new Accounting_Period__c(
            Name = Date.today().format() + ' Accounting Period', 
            Start_Date__c = startDate,
            End_Date__c = endDate,
            Status__c = 'Open'
        );
        return ap;
    }


    /***********************************
     * Affiliations
     ***********************************/

    /**
     * Create affiliations
     * No DML - returns unsaved list of sObjects
     * @param lstOrganizations Accounts for Contacts to be affiliated with
     * @param lstContacts Contacts to create affiliations for
     */

    public static List<npe5__Affiliation__c> createAffiliations(
        List<Account> lstOrganizations,
        List<Contact> lstContacts
    ) {
        List<npe5__Affiliation__c> lstAffiliations = new List<npe5__Affiliation__c>();
        for (Account org : lstOrganizations) {
            for (Contact ct : lstContacts) {
                lstAffiliations.add( 
                    new npe5__Affiliation__c(
                        npe5__Status__c = AFFILIATION_STATUS_CURRENT,
                        npe5__Contact__c = ct.Id,
                        npe5__Organization__c = org.Id
                    )
                );
            }
        }
        return lstAffiliations;
    }


    /***********************************
     * Contacts
     ***********************************/

    /**
     * Create contact sObjects without accounts
     * No DML - returns unsaved list of sObjects
     * @param Integer Number of contacts to create for each account
     */

    public static List<Contact> createContacts(
        Integer numberOfContacts
    ) {
        return generateContactsWithDefaults(numberOfContacts);
    }

    /**
     * Create contact sObjects for a preexisting list of accounts
     * No DML - returns unsaved list of sObjects
     * @param List<Account> Parent accounts for created contacts
     * @param Integer Number of contacts to create for each account
     * @return Contact[] New contacts
     */

    public static List<Contact> createContacts(
        List<Account> lstParentAccounts, Integer numberOfContacts
    ) {
        List<Contact> lstContacts = new List<Contact>();
        for (Account acc : lstParentAccounts) {
            List<Contact> lstAccountContacts = generateContactsWithDefaults(numberOfContacts);
            for (Contact ct : lstAccountContacts) {
                ct.AccountId = acc.Id;
            }
            lstContacts.addAll(lstAccountContacts);
        }
        return lstContacts;
    }

    /**
     * Create a list of default contacts with FirstName, LastName, Email, and Birthdate
     *     to be used by overloaded createContacts method
     * @param numberOfContacts Number of contacts to create
     */

    private static List<Contact> generateContactsWithDefaults(
        Integer numberOfContacts
    ) {
        List<Contact> lstDefaultCts = new List<Contact>();
        for (Integer i = 0; i < numberOfContacts; i++) {
            lstDefaultCts.add(
                new Contact(
                    FirstName  = CONTACT_BASE_FIRST_NAME + String.valueOf(i),
                    MiddleName = CONTACT_BASE_MIDDLE_NAME + String.valueOf(i),
                    LastName   = CONTACT_BASE_LAST_NAME + String.valueOf(i),
                    Email      = CONTACT_BASE_FIRST_NAME + CONTACT_BASE_LAST_NAME + String.valueOf(i) + '@testingstuff.com',
                    Birthdate  = CONTACT_BASE_BIRTHDATE.addYears(-i).addMonths(i)
                )
            );
        }
        return lstDefaultCts;
    }


    /***********************************
     * General Accounting Units (NPSP)
     ***********************************/

    /**
     * Create list of general accounting units
     * No DML - returns a single, unsaved public group
     */

    public static List<npsp__General_Accounting_Unit__c> createGeneralAccountingUnits(
        Integer numberOfGAUs
    ) {
        List<npsp__General_Accounting_Unit__c> lstGAUs = new List<npsp__General_Accounting_Unit__c>();
        for (Integer i = 0; i < numberOfGAUs; i++) {
            lstGAUs.add(
                new npsp__General_Accounting_Unit__c(
                    Name = 'Test GAU ' + String.valueOf(i),
                    GL_Code__c = '40-40-400-4000' + String.valueOf(i),
                    npsp__Active__c = true
                )
            );
        }
        return lstGAUs;
    }


    /***********************************
     * Groups
     ***********************************/

    /**
     * Create regular public group
     * No DML - returns a single, unsaved public group
     */

    public static Group createRegularGroup() {
        Group newGroup = new Group(
            Name = PUBLIC_GROUP_NAME, 
            Type = GROUP_TYPE_REGULAR, 
            DoesIncludeBosses = false, 
            DoesSendEmailToMembers = false
        );
        return newGroup;
    }

    /***********************************
     * Journal Entries (fsl)
     ***********************************/

    /**
     * Create manual adjustment journal entries for an open accounting period
     * No DML - returns unsaved list of sObjects
     * @param Id accountingPeriodId - Open accounting period to create jes for
     * @param Integer numberOfTransactions - number of journal entry pairs to create
     */

    public static List<Journal_Entry__c> createJournalEntries(
        Id accountingPeriodId,
        Integer numberOfTransactions
    ) {
        List<npsp__General_Accounting_Unit__c> lstTestGaus = createGeneralAccountingUnits(2);
        insert lstTestGaus;

        List<Journal_Entry__c> lstJEs = new List<Journal_Entry__c>();
        
        for (Integer i = 0; i < numberOfTransactions; i++) {
            Decimal jeAmount = 100 * (i+1);
            Date jeDate = Date.today();
            String postingStatus = 'Entered';
            String jeNotes = 'Manual adjustment';

            // Debit entry
            Journal_Entry__c jeDebit = new Journal_Entry__c();
            jeDebit.Accounting_Period__c = accountingPeriodId;
            jeDebit.Manual_Adjustment__c = true;
            jeDebit.Type__c = 'Debit';
            jeDebit.Amount__c = jeAmount;
            jeDebit.Date__c = jeDate;
            jeDebit.GL_Account_Name__c = lstTestGaus[0].Name;
            jeDebit.GL_Code__c = lstTestGaus[0].GL_Code__c;
            jeDebit.Posting_Status__c = postingStatus;
            jeDebit.General_Accounting_Unit__c = lstTestGaus[0].Id;
            jeDebit.Notes__c = jeNotes;
            lstJEs.add(jeDebit);

            // Credit entry
            Journal_Entry__c jeCredit = new Journal_Entry__c();
            jeCredit.Accounting_Period__c = accountingPeriodId;
            jeCredit.Manual_Adjustment__c = true;
            jeCredit.Type__c = 'Credit';
            jeCredit.Amount__c = jeAmount;
            jeCredit.Date__c = jeDate;
            jeCredit.GL_Account_Name__c = lstTestGaus[1].Name;
            jeCredit.GL_Code__c = lstTestGaus[1].GL_Code__c;
            jeCredit.Posting_Status__c = postingStatus;
            jeCredit.General_Accounting_Unit__c = lstTestGaus[1].Id;
            jeCredit.Notes__c = jeNotes;
            lstJEs.add(jeCredit);
        }

        return lstJEs;

    }


    /***********************************
     * Opportunities
     ***********************************/

    /**
     * Create opportunity sObjects for a list of contacts and an accounting state
     * No DML - returns unsaved list of sObjects
     * @param List<Contact> lstContacts - Parent primary contacts for created opps
     * @param Integer numberOfOppsPerContact - Number of opportunities to create for each contact
     * @param String strAccountingState - The accounting state that the opps should be in
     * @return Opportunity[] List of opportunity sObjects
     */

    public static List<Opportunity> createOpportunitiesForAccountingState(
        List<Contact> lstContacts, 
        Integer numberOfOppsPerContact, 
        String strAccountingState
    ) {
        // Create list of opps to return
        List<Opportunity> lstOpps = new List<Opportunity>();
        for (Contact ct : lstContacts) {
            for (Integer i = 0; i < numberOfOppsPerContact; i++) {
                lstOpps.add(
                    new Opportunity(
                        Name = 'Test Opportunity ' + ct.Id + '-' + String.valueOf(i),
                        AccountId = ct.AccountId,
                        npsp__Primary_Contact__c = ct.Id,
                        CloseDate = Date.today().addDays((i*-1)),
                        StageName = getOppStageFromAccState(strAccountingState),
                        Amount = 1000
                    )
                );
            }
        }
        // Return opps sobjects
        return lstOpps;
    }

    /**
     * Create opportunity sObject for a contact and an accounting state
     * No DML - returns unsaved list of sObjects
     * @param Contact contact - Primary contact for opportunity
     * @param Decimal amount - Opportunity total amount
     * @param String strAccountingState - The accounting state that the opps should be in
     * @return Opportunity[] List of opportunity sObjects
     */

     public static Opportunity createOpportunity(
        Contact contact, 
        Decimal amount, 
        String strAccountingState
    ) {
        return new Opportunity(
            Name = 'Test Opportunity ' + contact.Id,
            AccountId = contact.AccountId,
            npsp__Primary_Contact__c = contact.Id,
            CloseDate = Date.today(),
            StageName = getOppStageFromAccState(strAccountingState),
            Amount = amount
        );
    }

    /**
     * Get a valid opportunity stage for a provided accounting state
     * @param String strAccountingState - 'Uncommitted','Committed','Finalized'
     * @return String - Opportunity stage
     */

    public static String getOppStageFromAccState(
        String strAccountingState
    ) {
        if (mapStateToStages == null) {
            mapStateToStages = new Map<String, List<String>>();
            List<Accounting_State_Mapping__mdt> lstASMs = Accounting_State_Mapping__mdt.getAll().values();
            for (Accounting_State_Mapping__mdt asm : lstASMs) {
                if (!mapStateToStages.containsKey(asm.Accounting_State__c)) {
                    mapStateToStages.put(asm.Accounting_State__c, new List<String>());
                }
                List<String> lstStages = mapStateToStages.get(asm.Accounting_State__c);
                lstStages.add(asm.Opportunity_Stage__c);
                mapStateToStages.put(asm.Accounting_State__c, lstStages);
            }
        }
        return mapStateToStages.containsKey(strAccountingState) 
            ? mapStateToStages.get(strAccountingState).get(0)
            : 'Prospecting';
    }


    /***********************************
     * Users
     ***********************************/

    /**
     * Create internal standard user
     * No DML - returns unsaved sObject
     */

    public static User createStandardInternalUser() {
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = :STANDARD_USER_PROFILE_NAME LIMIT 1];

        User u = new User();
        u.IsActive          = true;
        u.ProfileId         = profile.Id;
        u.TimeZoneSidKey    = UserInfo.getTimeZone().toString();
        u.LocaleSidKey      = UserInfo.getLocale();
        u.LanguageLocaleKey = UserInfo.getLocale();
        u.EmailEncodingKey  = EMAIL_ENCODING_KEY;
        u.Username          = STANDARD_USER_USERNAME;
        u.Email             = STANDARD_USER_EMAIL;
        u.FirstName         = STANDARD_USER_FIRSTNAME;
        u.LastName          = STANDARD_USER_LASTNAME;
        u.Alias             = STANDARD_USER_ALIAS;
        return u;
    }


}