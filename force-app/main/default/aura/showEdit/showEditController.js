({
	doInit : function(component, event, helper) {
        component.set('v.bool', false);
        component.set('v.bool', true);
        console.log('hey atleast this?');
     //$A.enqueueAction(component.get('c.recall')); 
     // Added by naga to hide air dates for finance profile

     var action = component.get("c.fetchUserProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
               // component.set("v.userInfo", storeResponse);
              // alert('the profile name' +storeResponse);
               if(storeResponse ==='CC, TVL, PN – Finance')
                  {
                    component.set('v.hideAirDates',false);
                  }
               // $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
       var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        var loggedid = userId;
       // alert('the value of id' +loggedid);
        if (loggedid == "xyz"){
           component.set('v.showdelete',true);
        }
  
  
    },
	save : function(component, event, helper) {
        console.log(component.find('edit'));
        var ed = component.find('edit');
        if($A.util.isArray(ed)){
            ed = ed[0];
        }
		ed.get("e.recordSave").fire();
        //$A.get('e.force:refreshView').fire();
        //location.reload();
	},
	handleSaveSuccess : function(cmp, event) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();

        $A.get('e.force:refreshView').fire();
        location.reload();

    },
    recall : function(component, event, helper){
        console.log('Inside this ???');
        var that = this;
          console.log(component.find('edit'));
        var ed = component.find('edit');
        if($A.util.isArray(ed)){
            ed = ed[0];
        }  
        console.log('Inside this version 2');
         ed.get("e.recordSave").fire();  
         console.log('Inside this step 3');
           setTimeout(
        ed.setCallback(this , function() {
            console.log('Calling');
            this.recall(component, event, helper);
        }), 2000
    );
     $A.enqueueAction(ed);
      
        console.log('Inside this step 4');
    },
    printPDF: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        var cmpId = component.get("v.recordId"); 
        
        var redURL = '/apex/showPDFPage'+'?recid='+cmpId;
        urlEvent.setParams({
            "url" : window.open(redURL)
        });
        urlEvent.fire(); 
        
    },
    
    onDelete: function(component, event, helper){
       // var cmpId = component.get("v.recordId"); 
        var action = component.get("c.deleteShowRec");
        action.setParams({ showid : component.get("v.recordId") });
        action.setCallback(this, function(response) {
        var state = response.getState();
        var eUrl= $A.get("e.force:navigateToList");

            if (state === "SUCCESS") {
                alert('the record is deleted');
               // window.location.reload();
                eUrl.setParams({
                "listViewName": "Recent",
                "scope": "Show__c"
               });
             eUrl.fire();   
            }
         });
        
        $A.enqueueAction(action); 
     }
})