({
	doInit : function(component, event, helper) {
        helper.queryItems(component, helper);
    },
	editImageURL : function(component, event, helper) {
		component.set("v.imageMode","edit");
    },
	saveImageURL : function(component, event, helper) {
		helper.saveRecord(component,helper);
    }
})