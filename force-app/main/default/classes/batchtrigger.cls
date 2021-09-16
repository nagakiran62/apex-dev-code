global class batchtrigger implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
     
           
        String query = 'SELECT Id, Name FROM Account';
        return Database.getQueryLocator(query);
       
    }
    
    global void execute(Database.BatchableContext BC, List<account> accList) {
         for(Account acc : accList) {        
            // Update the Account Name 
            acc.Name = acc.Name + 'sfdcpoint';
        }
        try {
            // Update the Account Record
            update accList;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }

}