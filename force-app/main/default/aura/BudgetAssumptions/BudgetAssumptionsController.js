({
	init : function(component, event, helper) {            
        var today = new Date();
        today = today.toISOString().substring(0, 10);
        component.set('v.today', today);               
		var queryString = 'SELECT Budget_Notes__c, Id, Name, NumberofEps__c, Guild_Union_Coverage__c, CentralProductions__c, WBS_Element__c, ProductionType__c,'
        queryString +=     	'Covered_by_DGA__c, Covered_by_WGA__c, Covered_by_SAGAFTRA__c, Covered_By_IATSE__c,'
        queryString +=      'Production_Company_Account__c, Production_Company_Account__r.Name, Production_Company_Account__r.AccountNumber,'
        queryString += 		'Writing_Period_Complete_Date__c,PreProductioncompletedate__c,Production_Complete_Date__c,PostProductionCompleteDate__c,'
        queryString +=      'Content_Types__c, Production__c, Location_lookup__r.Name, Season__c, Below_The_Line_Description__c, Concept__c,'
        queryString +=      'Writing_Period_Start_Date__c, Pre_Production_Start_Date__c, Production_Start_Date__c, Post_Production_Start_Date__c, Delivery__c,'
        queryString +=      'EP_Writers__c, Number_of_Writers__c, Weeks__c, Other_text__c, Per_Contract__c, Assumptions__c,'
        queryString +=        '('
        queryString +=            'SELECT Id, Full_Name__c, Contact__r.Phone, Contact__r.Email, Contact__r.Title, Type__c'
        queryString +=            ' FROM Show_Contacts__r'
        queryString +=        '),'
        queryString +=        '('
        queryString +=            'SELECT Id, Name, Signatory__c, Signatory__r.Name'
        queryString +=            ' FROM Show_Rates__r'
        queryString +=        ')'
        queryString +=    ' FROM Show__c'
        queryString +=    ' WHERE Id = \'' + component.get('v.recordId') + '\' ';
        queryString +=    'LIMIT 1';
		//debugger;
        component.find('util').query(queryString, function(data){
            component.set('v.show', data[0]);
        })

        /*BEGIN, section that builds string with list of Guilds attached to show.*/
        var ratesForShowQuery = 'SELECT Guild__c from Show_Rate__c Where Show__c = \'' + component.get('v.recordId') + '\' ';
		var guilds_string = '';
        component.find('util').query(ratesForShowQuery, function(data){
            if(data.length > 0){
                for(var i = 0; i < data.length; i++){
                    guilds_string += data[i]['Guild__c'];
                    if(i != (data.length-1)){
                        guilds_string += '/';                        
                    }
                }
            }
            component.set('v.guildstring', guilds_string);
        })        
		
        helper.queryGetBudgetNotes(component,helper);
        helper.queryBudgetPeople(component,helper);
        helper.queryBudgetRentals(component,helper);        
        /*
        var action = component.get("c.queryBudgetPeople");
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this,function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if ( state === "SUCCESS" ){
                console.log("ressy resterston", res);
                component.set("v.budgetPerson",res);
            }
        })
        $A.enqueueAction(action);        
		/*
        /*END, section that builds string with list of Guilds attached to show.*/
        /*
         var recId = component.get("v.recordId");
        var action = component.get("c.getRoyaltyField");
        action.setParams({ recId : recId });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {

                var res = response.getReturnValue();
                //var show = res.Royalty__c;
                component.set("v.showRoyalty", res);
            }
            else if (state === "INCOMPLETE") {

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
        */
    },
    saveBudgetNotes : function(c,e,h){
		var notes = c.get("v.show.Budget_Notes__c");
		console.log("Show me notes --> ", notes);
        var record ={
            sobjectType : 'Show__c',
            Id : c.get("v.recordId"),
            Budget_Notes__c : notes,
        }
        c.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
        }); 
        
	 var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Budget Info was successfully saved.",
            "type": 'success'
        });
        toastEvent.fire();        
        //Budget_Notes__c     
        h.queryGetBudgetNotes(c,h);
    },

    deleteAssumptionRental : function(c,e,h){
		var recordId = e.srcElement.dataset.id;
		var action = c.get("c.deleteRecord");
		action.setParams({recordId:recordId});
		action.setCallback(this,function(response) {
	        var state = response.getState();
	        if ( state === "SUCCESS" ){
	        	h.queryBudgetRentals(c,h);
	        }
	    });
		$A.enqueueAction(action);
	  var toastEvent = $A.get("e.force:showToast");
	        toastEvent.setParams({
	            "title": "Success",
	            "message": "Rental Deleted"
	        });
	        toastEvent.fire();		    
    },

    deleteAssumption : function(c,e,h){
		var recordId = e.srcElement.dataset.id;
		var action = c.get("c.deleteRecord");
		action.setParams({recordId:recordId});
		action.setCallback(this,function(response) {
	        var state = response.getState();
	        if ( state === "SUCCESS" ){
	        	h.queryBudgetPeople(c,h);
	        }
	    });
		$A.enqueueAction(action);
	  var toastEvent = $A.get("e.force:showToast");
	        toastEvent.setParams({
	            "title": "Success",
	            "message": "Assumption Deleted"
	        });
	        toastEvent.fire();		    
    },

	save : function(component, event, helper){
		component.find('util').upsert(component.get('v.show'), function(response){
			$A.get('e.force:refreshView').fire();
		});
	},

    addBudgetPerson : function(cmp,evt,hlp){
        var recordId = cmp.get("v.recordId");
        var l = cmp.get("v.budgetPerson");
        l.push( hlp.addRow(recordId,"BudgetPerson") );
        cmp.set("v.budgetPerson",l);
    },

    addBudgetRental : function(cmp,evt,hlp){
        var recordId = cmp.get("v.recordId");
        var l = cmp.get("v.budgetRental");
        l.push( hlp.addRowRental(recordId,"BudgetRental") );
        cmp.set("v.budgetRental",l);
    },
    
    saveBudgetRentals : function(component, event, helper){
		var record = new Object();
		record = component.get("v.budgetRental");

        component.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
		})
		helper.queryBudgetRentals(component, helper);
    },
    
    saveBudgetPeople : function(component, event, helper){
		var record = new Object();
		record = component.get("v.budgetPerson");

        component.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
		})
		// put query results yo
		// 
		helper.queryBudgetPeople(component, helper);
    
    },
    clickCSV : function(component, event, helper){
      var urlEvent = $A.get("e.force:navigateToURL");
	  var cmpId = component.get("v.recordId");
	  var redURL = '/apex/exportBudgetDetailCSV'+'?recid='+cmpId;
        urlEvent.setParams({           
            "url" : window.open(redURL)                    
        });
        	urlEvent.fire();		
    },
    keyCheck : function(component, event, helper){ 
     var royaltyField = component.get("v.showRoyalty");
     var recId = component.get("v.recordId");   
     var action = component.get("c.updateShow");
      
     action.setParams({  royaltyField : royaltyField });  
    $A.enqueueAction(action);
    }
})