public class accController {
    
    @AuraEnabled
    public static List<Account> getacclist() {
        
        List<Account> acclst = [select id,name from account order by createdDate DESC limit 10];
            
            return acclst;
        
    }
}