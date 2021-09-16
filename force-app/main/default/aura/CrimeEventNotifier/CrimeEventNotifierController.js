({
	informHandler : function(component, event, helper) {
        
        //step 2 Get reference of event
        var crime = component.getEvent("crime");
        
        // step 3 set parameters
        crime.setParams({"message" : "Dawwod is coming"});
        
        // STEP 4 FIRE EVENT
        crime.fire();
	}
})