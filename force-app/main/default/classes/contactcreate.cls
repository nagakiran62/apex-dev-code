public with sharing class contactcreate {
    
  
      @AuraEnabled
      public static void createRecord (string v1){
          
          contact c = new contact(LastName= v1);
          
          insert c;
}
    
}