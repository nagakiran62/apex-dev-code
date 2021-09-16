({
	selectTab : function(component, event, helper) {
		//var clicked = event.srcElement.id;
		console.log(event)
		var clicked = event.target.id;
		var selected = clicked.substring(19,20);
		component.set("v.selected",selected);
	}
})