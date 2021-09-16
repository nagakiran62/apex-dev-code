({
    queryItems : function(component, helper){
        var recordId = component.get("v.recordId");
        var action = component.get("c.queryShow");
        action.setParams({showId:recordId});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
                console.log('--res--', res);
                component.set('v.show', res);
                helper.toggleMode(component,res);
            }
        })
        $A.enqueueAction(action);
    },
    saveRecord : function(component, helper){
        var show = component.get("v.show");
        var action = component.get("c.saveShow");
//        var imageURL = component.find("imageURL").get("v.value");
        console.log(show);
        action.setParams({show:show});
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log(state);
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
                console.log(res);
                helper.toggleMode(component,res);
            }
        })
        if ( show.Image_URL__c != null ){
            $A.enqueueAction(action);
        }
    },
    toggleMode : function(component, show){
        console.log("toggle",show);
        if ( show.Image_URL__c != null ){
            component.set("v.imageMode","view");
        } else {
            component.set("v.imageMode","edit");
        }
    }

})