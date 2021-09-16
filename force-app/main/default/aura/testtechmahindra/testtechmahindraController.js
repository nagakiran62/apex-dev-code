({
	searchaccount : function(component, event, helper) {
        console.log('inside the function');
        
        var action = component.get("c.displayaccount");
        
         //console.log('inside the function 1' +v1);
     
        
        action.setParams({
            searchvalue: component.get("v.searchvalue")
       });
        
        action.setCallback(this, function(data) {
          component.set("v.accountslist", data.getReturnValue());
     });
        
       $A.enqueueAction(action); 
        
        
		
   }	
})