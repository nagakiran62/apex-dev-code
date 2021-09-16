global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    
        global Database.QueryLocator start(Database.BatchableContext bc) {
            
            return Database.getQueryLocator(
            'SELECT ID, LeadSource FROM Lead'
        );
            
        }

        global void execute(Database.BatchableContext bc, List<Lead> scope){
            List<lead> lstleads = new List<lead>();
            For(Lead l:scope){
                l.LeadSource='Dreamforce';
                lstleads.add(l);
            }
            Update lstleads;
            
        }
    
       global void finish(Database.BatchableContext bc){
           
       }
}