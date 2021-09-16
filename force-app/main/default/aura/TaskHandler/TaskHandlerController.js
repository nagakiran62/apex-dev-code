({
	handleControl : function(component, event, helper) {
        
        var message = event.getParam("message");
        
        //alert("text" +message);
        helper.callserver(component,"c.FetchallAcc","v.acclist",{"params" : message});
		
	}
})