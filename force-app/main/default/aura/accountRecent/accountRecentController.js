({
	getAccountList : function(component, event, helper) {
        
        var action = component.get("c.getacclist");
        
        action.setCallback(this, function(response) {
		var state = response.getState();
            
        if(state === 'SUCCESS') {
            
            var accList = response.getReturnValue();
            alert('the account' +JSON.stringify(accList));
            component.set("v.AccountList",accList);
        }
         });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
        }    
})