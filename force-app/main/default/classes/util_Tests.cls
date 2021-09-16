@isTest
private class util_Tests {

    //static List<Account> testAccounts = testDataFactory.createTestRecords(new Account[10]);

    @testSetup static void setup(){
    	List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;
    }

    static TestMethod void queryTests(){
    	String queryString = 'SELECT Id FROM Account';

        Test.startTest();
        	List<sObject> records = util_Controller.query(queryString);
        Test.stopTest();

        system.assertEquals(records.size(), 2);

        String s;
        util.fixNull(s);
        Integer i;
        util.fixNull(i);
        Decimal d;
        util.fixNull(d);

        List<Schema.PicklistEntry> picklist = Account.Type.getDescribe().getPicklistValues();
        util.picklistToSelectOptions(picklist,'--Select One--');
    }

    static TestMethod void upsertTests(){
    	List<sobject> accounts = database.query('select id from account');
    	accounts.add(new Account(Name = 'Test'));

    	Test.startTest();
    		List<sObject> records = util_Controller.upsertRecords(accounts);
    	Test.stopTest();

    	system.assertEquals(records.size(), 3);
    }

    static TestMethod void deleteTests(){
    	List<sobject> accounts = database.query('select id from account');
    	accounts.add(new Account(Name = 'Test'));

    	Test.startTest();
    		util_Controller.deleteRecords(new List<sObject>{accounts[0]} );
    	Test.stopTest();

    	List<sObject> records = database.query('select id from account');

    	system.assertEquals(records.size(), 1);
    }

    static TestMethod void queryTest(){
    	String sObjectType = 'Account';
    	String whereClause = 'WHERE Id != null';
    	String orderBy = 'ORDER BY CreatedDate';
    	String lim = 'LIMIT 10';
    	List<String> fields = new List<String>{'Id', 'Name'};

    	Test.startTest();
    		List<sObject> records = util_Controller.queryRecords(sobjectType, whereClause, OrderBy, lim, fields);
    	Test.stopTest();

    	system.assertEquals(records.size(), 2);
    }

}