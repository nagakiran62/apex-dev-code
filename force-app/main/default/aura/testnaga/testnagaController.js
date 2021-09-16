({
	addon : function(component, event, helper) {
        var val1 = component.get("v.value1");
         var val2 = component.get("v.value2");
        var result=  parseInt(val1)+ parseInt(val2);
        
        component.set("v.result",result);
		
	}
})