({
	handleCrime : function(component, event, helper) {
        
        //step 3 Get parameters
		var message = event.getParam("message");
        
        //step 4 take action
        alert("recieved action  :" +message);
	}
})