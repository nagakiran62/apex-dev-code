public class findAccount {

   
    
     @auraEnabled
   public Static list<Account> FetchallAcc(string params){
        return[Select name,phone,type
               from account where name =:params];
    }
    
}