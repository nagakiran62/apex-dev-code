public class branchHandler {
    
    public static void updateAccountType(list<branch__c> lstbranch){
        system.debug('inside class');
        List<Branch__C> lstbranchnew = new list<branch__c>();
        lstbranchnew =[select id,name,Account__c,Account__r.Type,Account__r.tree_name__c from branch__c where id IN :lstbranch];
        List<id> lstupdateids = new list<id>();
        List<Account> lstAccount = new list<Account>();
        List<Account> lstupdateAccount = new list<Account>();
        for(branch__c b : lstbranchnew){
            if(b.Account__c!=null){
               
                string treename= b.Account__r.tree_name__c;
                 system.debug('the value' +treename);
                if((b.Account__r.Type == 'Prospect')&&(treename.startsWith('33'))){
                    lstupdateids.add(b.Account__c);
                   system.debug('the value 2' +lstupdateids); 
                }
            }
            
        }
        
        if(lstupdateids != null){
            system.debug('the value 3' +lstupdateids); 
            lstAccount =[select id,name,type from account where ID IN :lstupdateids];
            for(Account acc : lstAccount ){
                acc.type= 'Customer';
                lstupdateAccount.add(acc);
            }
            update lstupdateAccount;
        }
    }

}