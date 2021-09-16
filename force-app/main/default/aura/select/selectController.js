({
	loadfirstname : function(component, event, helper) {
		/*var action = component.get("c.firstname"); // step 1
        action.setCallback(this, function(response){ // step 2
            if(response.getState()==="SUCCESS" && component.isValid()){ // step 3
                component.set("v.firstname",response.getReturnValue()); 
            console.log(response.getReturnValue());
	}
})
        $A.enqueueAction(action); // step 4*/
        
        
        var action1 = component.get("c.getContactdetails"); // step 1
       
        
        action1.setCallback(this, function(response){ // step 2
             
            if(response.getState()==="SUCCESS" && component.isValid()){ // step 3
                component.set("v.fullcontact",response.getReturnValue()); 
            console.log(response.getReturnValue());
	}
            
})
        
        $A.enqueueAction(action1); // step 4
        component.set("v.texttest",'testttttttttt'); 
        
    }
    

     
})