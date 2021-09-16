({
    doInit: function(component, event, helper) {
        
        var action = component.get('c.queryShow');
        action.setParams({
            "showId": component.get("v.recordId")
        });
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.showRecord', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
        

    },
   saveRecordCntrlr : function(component, event, helper) {
         var status= event.getSource().get("v.value");
        var whichOne = event.getSource().getLocalId();  
       alert('the value' +whichOne);
       
       
       var action = component.get('c.updateshowfieldsNow');
        action.setParams({
            "showid": component.get("v.recordId"),
            "statusfield" : status,
            "typeofchecklist" :whichOne
        });
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state= actionResult.getState();
            if(state=='SUCCESS'){
                //add message or something
            }
        });
        $A.enqueueAction(action);
       
   },
    
  setOutput : function(component, event, helper) {
    var todayVal = component.find("firstshoot").get("v.value");
    var netcon = component.find("networkcontact").get("v.value");
    var greelig = component.find("greenlight").get("v.value");
    var postgui = component.find("postguidelines").get("v.value");
    var kicoff = component.find("kickoff").get("v.value");
    var scekick = component.find("scenekickoff").get("v.value");
    var crelis = component.find("crewlist").get("v.value");
    var vtrem = component.find("VTRremainder").get("v.value");
    var cosrep = component.find("Costreport").get("v.value");
    var cal = component.find("Calendar").get("v.value");

    var guilines = component.find("guidelines").get("v.value");
    var start = component.find("vmninsurance").get("v.value");
    var end = component.find("vmninsuranceend").get("v.value");
      alert('the value' +todayVal);
      
      var action = component.get('c.saveTasksShowsNow');
        action.setParams({
            "showid": component.get("v.recordId"),
            "firstshoot" : todayVal,
            "networkContact" : netcon,
            "greenLight" : greelig,
            "postGuidelines" : postgui,
            "kickOff" : kicoff,
            "sceneKick" : scekick,
            "crewList" : crelis,
            "vtrRem" : vtrem,
            "costReport" : cosrep,
            "calendar" : cal,
            "guidelinesEmail" : guilines,
            "startdate" : start,
            "endate" : end
        });
      
      var self = this;
        action.setCallback(this, function(actionResult) {
            var state= actionResult.getState();
            if(state=='SUCCESS'){
                alert('record saved');
            }
        });
        $A.enqueueAction(action);
  }
})