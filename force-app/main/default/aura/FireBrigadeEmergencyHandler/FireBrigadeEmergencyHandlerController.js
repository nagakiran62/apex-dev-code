({
	handleEmergency : function(component, event, helper) {
        //get param from event
        var message=event.getParam("message");
        //take action
        alert("fire brigade" +message);
		
	}
})