({
	getAllAccs : function(component, event, helper) {
		component.display(component, event, helper); 
        helper.callserver(component,"c.FetchallAcc","v.accList");
	},
    
    getaccs : function(component, event, helper) {
		component.display(component, event, helper); 
        helper.callserver(component,"c.FetchallDirectAcc","v.accList");
	},
    displayToast : function(component, event, helper) {
        var toastEvent= $A.get("e.force:showToast");   
        if(toastEvent){
            toastEvent.setParams({"message" :"Accs are loaded",
                                  "title" :"success message",
                                  "type" :"success"
                                 });
            toastEvent.fire();
        }else{
            alert("opps are loaded");
        }
    }
    
})