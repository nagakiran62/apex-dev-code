({	
	doInit : function(component, event, helper) {
		helper.queryFiles(component);
        helper.getFiles(component,event,helper);
		component.find('util').queryPicklistValues('ContentVersion', 'Type__c', function(response){
			component.set('v.standardPicklists', JSON.parse(response));
			console.log(component.get('v.standardPicklists'));
		})
		

	},
    toggle : function(component, event, helper) {
		var src = event.srcElement;
		var target = event.target;
		var x = parseInt(src.dataset.id);
		var folders = component.get("v.folders");
		folders[x].isExpanded = !folders[x].isExpanded;
		component.set("v.folders",folders);
	},
	openModal: function(component, event, helper) {
		//helper.openModal(component, event, helper);
		component.set('v.modalOpen', true);
	},

	openExport : function(component, event, helper){
		component.set('v.exporterOpen', true);
	},

	closeModal : function(component, event, helper) {
		//helper.closeModal(component, event, helper);
		component.set('v.modalOpen', false);
		component.set("v.uploadedFiles",[]);
        component.set("v.uploadDate",null);
	},
	saveFileAsEvent : function(component, event, helper){
		var recordId = component.get("v.recordId");
        var fileList = component.get("v.uploadedFiles");
        var uploadDate = component.get("v.uploadDate");
        var uploadType = component.find("types").get("v.value");
        var otherType = component.get('v.otherType');
        var action = component.get("c.createEventForContent");
        var standardPicklists = component.get('v.standardPicklists');
        var isStandard = false;
        standardPicklists.forEach(function(picklist){
        	if(picklist == uploadType){
        		isStandard = true;
        	}
        });

        if(!isStandard){
        	otherType = uploadType;
        	uploadType = 'Other';
        }

        action.setParams({
            showId: recordId,
            uploadDate : uploadDate,
            uploadType : uploadType,
            contentListString: JSON.stringify(fileList),
            otherType : otherType
        });
        console.log("uploadType");
		console.log(fileList);
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            var folders = [];
            console.log(res);
            for ( var key in res ) {
                folders.push( {isExpanded:true, Name:key, Files:res[key]});
            }
            component.set("v.folders",folders);
            component.set("v.uploadDate", null);
            component.set("v.uploadType", "");
            component.set('v.modalOpen', false);
            component.set("v.uploadedFiles",[]);
        	//component.set("v.uploadDate",null);
            //helper.closeModal(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    openDoc : function(component, event, helper){
    	var docId = event.target.getAttribute('data-title');
		console.log(docId);
		$A.get('e.lightning:openFiles').fire({
			recordIds : [ docId ]
		});
    }

})