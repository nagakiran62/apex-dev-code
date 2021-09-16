({
	getAllOpps : function(component, event, helper) {
        component.display(component, event, helper);   
        helper.callserver(component,"c.FetchallOpp","v.oppList");
	}, // end of method1
    
   getAllWonOpps : function(component, event, helper) {
       component.display(component, event, helper);
       helper.callserver(component,"c.FetchallwonOpp","v.oppList");     
}, // end of method2
    
    displayToast : function(component, event, helper) {
        var toastEvent= $A.get("e.force:showToast");   
        if(toastEvent){
            toastEvent.setParams({"message" :"opps are loaded",
                                  "title" :"success message",
                                  "type" :"success"
                                 });
            toastEvent.fire();
        }else{
            alert("opps are loaded");
        }
    },
    ShowSpinner : function(component, event, helper) {
        
        var spinner= component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
    
    },
    hideSpinner : function(component, event, helper) {
      var spinner = component.find("spinner");
        $A.util.addClass(spinner,"slds-hide");
    }
    
})