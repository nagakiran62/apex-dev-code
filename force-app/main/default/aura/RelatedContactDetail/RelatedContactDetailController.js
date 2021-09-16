({
	getContactDetail : function(component, event, helper) {
		alert('contact detail called');
		var accountId = event.getParam("accountId");
		//var self = this;
        alert('contact js controller' + accountId);
        /*var action = component.get('c.getContactDetail');
        action.setParams({
            "recordId": accountId
            
        });
        action.setCallback(this, function(actionResult) {
         component.set('v.contacts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);*/
      
    }
})