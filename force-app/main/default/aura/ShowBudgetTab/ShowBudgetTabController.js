({
	selectTab : function(component, event, helper) {
        var clicked = event.srcElement.id;
		var selected = clicked.substring(12,13);
		component.set("v.selected",selected);
	}
})