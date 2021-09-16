public class AccountProcessor {
    
    @future 
    public static void countContacts(List<ID> acc){
        
        List<Account> lstacc = new list<Account> ();
        
        for(ID a : acc){ 
        
        Integer contactCount = [SELECT COUNT() FROM Contact where AccountId = :a];
            
            //a.Number_of_Contacts__c = contactCount;
           Account aaa = new account();
            aaa.id= a;
            aaa.Number_of_Contacts__c =  contactCount;
            lstacc.add(aaa);
        }
         upsert lstacc;
    }

}