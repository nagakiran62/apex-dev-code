({
	handleClick : function(component, event, helper) {
        //set all buttons variant to neutral
        for(var i=1; i<=3;i++){
            var btn = component.find(i);
            btn.set("v.variant","neutral");
        }
       
		//for standard attribute get refrencing and access like below
        var btnClicked = event.getSource();
        //var btnClickedLabel = btnClicked.get("v.label");
        btnClicked.set("v.variant","brand");
        //alert('u clicked' +btnClickedLabel);
        
	}
})