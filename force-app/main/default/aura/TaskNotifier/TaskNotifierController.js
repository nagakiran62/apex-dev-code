({
	informHandler : function(component, event, helper) {
        
        var task = component.getEvent("task");
        var searchtext = component.get("v.msg");
        
        // step 3 set parameters
        task.setParams({"message" : searchtext});
        
        // STEP 4 FIRE EVENT
        task.fire();
		
	}
})