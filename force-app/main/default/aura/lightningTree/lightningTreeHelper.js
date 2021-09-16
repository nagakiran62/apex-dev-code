({  
   apexMethod : function(cmp) {  
     var action = cmp.get("c.getAccountHierarchy");  
     action.setParams({ accountId : cmp.get("v.recordId") });  
     action.setCallback(this, function(response) {  
       var state = response.getState();  
       if (state === "SUCCESS") {  
         cmp.set( "v.items", response.getReturnValue());  
       }  
     });  
     $A.enqueueAction(action);  
   }  
 })