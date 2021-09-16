({
	onSubmit : function(component, event, helper) {
		var cont = component.get("v.cont");
        helper.callserver(component,
                          "c.createContact","v.status",{"con" : cont});
	},
    
    validateLastName : function(component, event, helper) {
        
        var btn = component.find("btn");
        var cont = component.get("v.cont.LastName");
        if(cont.length>=3){
            btn.set("v.disabled",false);
        }else{
            btn.set("v.disabled",true);
        }
        
        
    }
})