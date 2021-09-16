({
	handleSelect : function(component, event, helper) {
		var selectedMenuItemValue = event.getParam("value");
        //alert("the selectedMenuItemValue is" +selectedMenuItemValue);
        $A.createComponent("c:ModalDialog",
                           {"title": "Message",
                            "body": "This feature is not available"
                           },
                           function(myBox){
                               //get reference to the div
                              var modalDiv= component.find("modalDiv");
                               //get copy of div's body
                              var modalDivBody= modalDiv.get("v.body");
                               //push component into the copy of the div's body
                               modalDivBody.push(myBox);
                               //push again into div
                               modalDiv.set("v.body",modalDivBody);
                           }
                          
                          );
	}
})