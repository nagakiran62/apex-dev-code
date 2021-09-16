({
	viewRecord : function(component, event, helper) {
        //get record id from component
        var id = component.get("v.sid");
        //get reference to event
        var refEvent = $A.get("e.force:navigateToSObject");
        //set params
        if(refEvent){
            refEvent.setParams({"recordId" : id});
            refEvent.fire();
        }else{
            alert("Please use LEX or salesforce app");
        }
		
	},
    
    editRecord : function(component, event, helper) {
        //get record id from component
        var id = component.get("v.sid");
        //get reference to event
        var refEvent = $A.get("e.force:editRecord");
        //set params
        if(refEvent){
            refEvent.setParams({"recordId" : id});
            refEvent.fire();
        }else{
            alert("Please use LEX or salesforce app");
        }
		
	},
})