({
	queryDatabase : function(component, event, helper) {
		var params = event.getParam('arguments');

		if(params){
			helper.callAction(component, 'c.query', params, params.callback, params.failureCallback);
		}

	},
	upsertRecs: function(component, event, helper){

		var params = event.getParam('arguments');

		if(params){

			if(!$A.util.isArray(params.records)){
				params.records = [params.records];
			}

			helper.callAction(component, 'c.upsertRecords', params, params.callback, params.failureCallback);
		}
	},

	deleteRecs: function(component, event, helper){
		var params = event.getParam('arguments');

		if(!$A.util.isArray(params.records)){
				params.records = [params.records];
		}

		if(params){
			helper.callAction(component, 'c.deleteRecords', params, params.callback, params.failureCallback);
		}
	},

	queryRecs : function(component, event, helper){
		var params = event.getParam('arguments');

		if(params){
			helper.callAction(component, 'c.queryRecords', params, params.callback, params.failureCallback);
		}
	},

	queryPicklist : function(component, event, helper){
		var params = event.getParam('arguments');

		if(params){
			helper.callAction(component, 'c.getPicklistValues', params, params.callback, params.failureCallback);
		}
	}
	
})