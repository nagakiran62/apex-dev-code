public class contactTriggerHelper {
    
    public static void updateAccount (List<contact> lstcont){
        
        Set<Id> acctIds = new Set<Id>();
        for (Contact c : lstcont) {
     
        if (c.AccountId != null) {
            acctIds.add(c.AccountId);
        }
    }
   
    List<Account> acctsToRollup = new List<Account>();
    
    
    for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds 
                               GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId'); 
        a.Number_Of_Contacts__c = (Integer) ar.get('ContactCount');
        acctsToRollup.add(a);
    }
    
   
    update acctsToRollup;

        
    }

}