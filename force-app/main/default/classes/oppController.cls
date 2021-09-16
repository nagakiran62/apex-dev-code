public class oppController {
 
    @auraEnabled
   public Static list<Opportunity> FetchallOpp(){
        return[Select name,stagename,amount
               from Opportunity];
    }
    @auraEnabled
    public Static list<Opportunity> FetchallwonOpp(){
        return[Select name,stagename,amount
               from Opportunity where stagename= 'Closed Won'];
    }
}