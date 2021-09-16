public class AccountController {
    
    @auraEnabled
   public Static list<Account> FetchallAcc(){
        return[Select id,name,phone,type
               from account];
    }
    @auraEnabled
    public Static list<Account> FetchallDirectAcc(){
        return[Select name,phone,type
               from account where type = 'Customer - Direct'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> findAccounts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE :key  LIMIT 10];
    }

}