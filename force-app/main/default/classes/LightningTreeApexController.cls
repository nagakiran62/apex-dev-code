public class LightningTreeApexController {  
     
   @AuraEnabled  
   public static List<items> getAccountHierarchy(Id accountId) {  
       
     //Wrapper instance  
     List<items> finalWrp = new List<items>();  
       
     //Going upto 2 level only as per SOQL limit  
     for(Account acc : [ Select Id, Name, Type, ParentId, Parent.Name, Parent.Type, Parent.ParentId, Parent.Parent.Name, Parent.Parent.Type From Account Where Id =: accountId]) {  
         
       //populating wrapper  
       List<items> trP1 = new List<items>{new items(acc.Type, acc.Name, false, null)};  
       List<items> trP2 = new List<items>{new items(acc.Parent.Type, acc.Parent.Name, false, trP1)};  
       finalWrp.add(new items(acc.Parent.Parent.Type, acc.Parent.Parent.Name, false, trP2));  
     }             
        
     System.debug('finalWrp:::' + finalWrp);  
     // return wrapper  
     return finalWrp;    
   }  
     public class items {  
     
   @AuraEnabled  
   public string label { get; set; }  
     
   @AuraEnabled  
   public string name { get; set; }  
     
   @AuraEnabled  
   public Boolean expanded { get; set; }  
     
   @AuraEnabled  
   public List<items> items { get; set; }  
     
   public items( String name, String label, Boolean expanded, List<items> items) {  
     this.label = label;  
     this.name = name;  
     this.expanded = expanded;  
     this.items = items;   
   }  
 }  
 }