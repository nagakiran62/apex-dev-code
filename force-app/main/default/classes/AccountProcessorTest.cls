@IsTest
public class AccountProcessorTest {
    
    @Istest static void TestcountContacts(){
        
        Account a = new account();
        a.Name ='test';
        Insert a;
        
        List<Id> lstid = new List<Id> ();
        lstid.add(a.id);
        Test.startTest();
        AccountProcessor.countContacts(lstid);
        Test.stopTest();
    }

}