({
	add : function(component, event, helper) {
		
      var value1=  component.get("v.value1");
      var value2=  component.get("v.value2");
      var result=  parseInt(value1)+ parseInt(value2);
        //alert("in add:" +result);
        component.set("v.result",result)
	},
    sub : function(component, event, helper) {
		
        var value1=  component.get("v.value1");
        var value2=  component.get("v.value2");
        var result=  value1-value2;
        //alert("in SUB:" +result);
        component.set("v.result",result)
	},
    mul : function(component, event, helper) {
		
              var value1=  component.get("v.value1");
      var value2=  component.get("v.value2");
      var result=  parseInt(value1) * parseInt(value2);
        //alert("in MUL:" +result);
        component.set("v.result",result)
	},
    div : function(component, event, helper) {
		
              var value1=  component.get("v.value1");
      var value2=  component.get("v.value2");
      var result=  parseInt(value1)/ parseInt(value2);
        //alert("in DIV:" +result);
        component.set("v.result",result)
	},
})