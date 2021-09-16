({
	create : function(component, event, helper) {
        
        var v1 = component.get("v.value1");
		
        //step 1: setting action varaible
        var action = component.get("c.createRecord");
        //step 2 set params
        action.setParams({
            v1 : v1 // both should be same
        });
        
         // step 3Setting the Callback
        action.setCallback(this,function(a){
            // step 4get the response state
            var state = a.getState();
            
            if (component.isValid() && state === "SUCCESS") {
            // put the data into a private component attribute
           //component.set('v.students ',responsegetReturnValue());
          component.set("v.result",v1);
           // You would typically fire an event here to trigger
          // client-side notification that the server-side action completed
            }
            
            
            });
            // step 5
            $A.enqueueAction(action);
        
        
	},
 onCaptChange : function(component, event, helper){

 var selectedVal =
 component.find("idCaptain").get('v.value');

 alert("You selected " + selectedVal );
}
})