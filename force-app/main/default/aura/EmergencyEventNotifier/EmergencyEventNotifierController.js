({
	dial911 : function(component, event, helper) {
        // 1) get reference for the event using $A.get
        var emergencyEvent = $A.get("e.c:EmergencyEvent");
        
        //2)set params in JSONformat
        emergencyEvent.setParams({"message": "House on fire"});
        
       //3)fire the event
       
		emergencyEvent.fire();
	}
})